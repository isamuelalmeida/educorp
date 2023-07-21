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

    ## Deploy a Prometheus instance
    ##
    prometheus:
      prometheusSpec:
        enableRemoteWriteReceiver: true
        enableFeatures:
        - web.enable-remote-write-receiver
        - memory-snapshot-on-shutdown
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
                - https://callink${contains(["production"], var.environment) ? "" : ".${var.environment}"}.educorp.app
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
