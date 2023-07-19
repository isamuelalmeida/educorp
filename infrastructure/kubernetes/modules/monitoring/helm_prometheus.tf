resource "helm_release" "prometheus" {
  atomic = true

  repository = "https://prometheus-community.github.io/helm-charts"

  name    = "prometheus"
  chart   = "kube-prometheus-stack"
  version = "46.4.2"

  namespace        = "prometheus"
  create_namespace = true

  timeout = 180

  values = [<<-EOT
    defaultRules:
      create: false

    alertmanager:
      enabled: false

    grafana:
      enabled: false

    prometheusOperator:
      nodeSelector:
        nodeTypeClass: observability

    ## Deploy a Prometheus instance
    ##
    prometheus:
      prometheusSpec:
        nodeSelector:
          nodeTypeClass: observability
        enableRemoteWriteReceiver: true
        enableFeatures:
        - web.enable-remote-write-receiver
        - memory-snapshot-on-shutdown
        remoteWrite:
          - headers:
              X-Scope-OrgID: platos-nonprod
            url: http://vpce-0bc35cf61c9541e46-1trpknuf.vpce-svc-010e9aedbb2d9c327.us-east-1.vpce.amazonaws.com:8080/api/v1/push #Endpoint do Grafana Mimir Central da Ampli
        retention: 60d
        retentionSize: 49GB
        storageSpec:
          volumeClaimTemplate:
            spec:
              accessModes: ["ReadWriteOnce"]
              resources:
                requests:
                  storage: 50Gi
        externalLabels:
          cluster: k8s-platos-${var.environment}
        resources:
          limits:
            cpu: 2000m
            memory: 6Gi
          requests:
            cpu: 1000m
            memory: 4Gi
        additionalScrapeConfigs:          
          - job_name: 'kubernetes-pods'
            kubernetes_sd_configs:
            - role: pod
            relabel_configs:
            - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
              action: keep
              regex: true
            - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
              action: replace
              target_label: __metrics_path__
              regex: (.+)
            - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
              action: replace
              regex: ([^:]+)(?::\d+)?;(\d+)
              replacement: $1:$2
              target_label: __address__
            - action: labelmap
              regex: __meta_kubernetes_pod_label_(.+)
            - source_labels: [__meta_kubernetes_namespace]
              action: replace
              target_label: kubernetes_namespace
            - source_labels: [__meta_kubernetes_pod_name]
              action: replace
              target_label: kubernetes_pod_name
          - job_name: 'gitlab-ci-pipelines-exporter'
            scrape_interval: 30s
            scrape_timeout: 10s
            static_configs:
              - targets: ['gitlab-ci-pipelines-exporter:8080']
          - job_name: 'blackbox'
            metrics_path: /probe
            params:
              module: [http_2xx]
            static_configs:
              - targets:
                - https://kroton${contains(["production"], var.environment) ? "" : ".${var.environment}"}.platosedu.io/erp
                - https://kroton${contains(["production"], var.environment) ? "" : ".${var.environment}"}.platosedu.io/lms
                - https://upf${contains(["production"], var.environment) ? "" : ".${var.environment}"}.platosedu.io
                - https://umc${contains(["production"], var.environment) ? "" : ".${var.environment}"}.platosedu.io
                - https://utp${contains(["production"], var.environment) ? "" : ".${var.environment}"}.platosedu.io
                - http://service-payment.service-payment:8081/health
                - http://service-bankslip.service-bankslip:8081/health
            relabel_configs:
            - source_labels: [__address__]
              target_label: __param_target
            - source_labels: [__param_target]
              target_label: target
            - target_label: __address__ 
              replacement: prometheus-blackbox-exporter.prometheus:9115
    EOT
  ]
}

resource "helm_release" "prometheus_postgres_exporter" {
  atomic = true

  repository = "https://prometheus-community.github.io/helm-charts"

  name    = "rds-cosmos"
  chart   = "prometheus-postgres-exporter"
  version = "2.10.1"

  namespace = "prometheus"

  values = [<<-EOT
      annotations:
        prometheus.io/port: "9187"
        prometheus.io/scrape: "true"

      resources:
        limits:
          cpu: 1000m
          memory: 128Mi
        requests:
          cpu: 500m
          memory: 64Mi

      config:
        datasource:
          host: ${var.cosmos_database_instance_address}
          user: ${var.cosmos_monitoring_database_username}
          password: ${var.cosmos_monitoring_database_password}
          database: "postgres"
  
    EOT
  ]
}

resource "helm_release" "gitlab_ci_pipelines_exporter" {
  count = var.environment == "production" ? 1 : 0

  atomic = true

  repository = "https://charts.visonneau.fr"

  name    = "gitlab-ci-pipelines-exporter"
  chart   = "gitlab-ci-pipelines-exporter"
  version = "v0.2.6"

  namespace = "prometheus"

  values = [<<-EOT
    redis:
      enabled: false
    config:
      log:
        level: debug
      gitlab:
        url: https://gitlab.com
        token: ${var.prometheus_gitlab_token}
      wildcards:
        - owner:
            name: platosedu
            kind: group
            include_subgroups: true
      project_defaults:
        pull:
          refs:
            branches:
              enabled: true
              regexp: "^main|master|stage|dev$"
              most_recent: 10
            tags:
              enabled: false
            merge_requests:
              enabled: true
              most_recent: 10
          pipeline:
            jobs:
              enabled: true
    EOT
  ]
}
