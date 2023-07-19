resource "helm_release" "tempo" {
  depends_on = [helm_release.grafana]

  atomic = true

  repository = "https://grafana.github.io/helm-charts"

  name    = "tempo"
  chart   = "tempo-distributed"
  version = "1.4.2"

  namespace = "grafana"

  timeout = 240

  values = [<<-EOT
    fullnameOverride: tempo

    tempo:
      structuredConfig:
        query_frontend:
          max_retries: 5
          search:
            max_duration: 1h  # Range máximo de tempo para pesquisar por traces
            concurrent_jobs: 2000

    server:
      httpListenPort: 3100
      logLevel: info
      logFormat: logfmt
      grpc_server_max_recv_msg_size: 8388608
      grpc_server_max_send_msg_size: 8388608


    global_overrides:
      per_tenant_override_config: /conf/overrides.yaml
      ingestion_burst_size_bytes: 60000000
      ingestion_rate_limit_bytes: 50000000
      max_bytes_per_trace: 10000000
      max_bytes_per_tag_values_query: 10000000
      metrics_generator_processors:
        - service-graphs
        - span-metrics

    
    metricsGenerator:
      enabled: true
      replicas: 1
      config:
        registry:
          collection_interval: 60s
          stale_duration: 5m
#          external_labels:
#            cluster: k8s-platos-${var.environment}
        processor:
          span_metrics:
            dimensions: ['http.host','net.host.name','http.method','http.url','http.target','http.status_code','http.client_ip','http.user_agent']
        storage:
          remote_write:
          - url: http://prometheus-operated.prometheus:9090/api/v1/write
      resources:
        limits:
          cpu: 200m
          memory: 1024Mi
        requests:
          cpu: 100m
          memory: 512Mi
      nodeSelector:
        nodeTypeClass: observability
    
    metaMonitoring:
      serviceMonitor:
        enabled: true
        namespaceSelector:
          matchNames:
            - grafana
        labels:
          release: prometheus
        interval: 30s
      grafanaAgent:
        enabled: false
        installOperator: false

    memcached:
      enabled: true
      host: memcached
      resources:
        limits:
          cpu: 50m
          memory: 256Mi
        requests:
          cpu: 10m
          memory: 64Mi

    compactor:
      replicas: 1
      resources:
        limits:
          cpu: 500m
          memory: 2048Mi
        requests:
          cpu: 200m
          memory: 512Mi
      config:
        compaction:
          block_retention: 48h   # Tempo de persistência dos dados
      nodeSelector:
        nodeTypeClass: observability

    ingester:
      replicas: 1
      resources:
        limits:
          cpu: 200m
          memory: 2048Mi
        requests:
          cpu: 100m
          memory: 512Mi
      config:
        replication_factor: 1
        max_block_bytes: 50000000
        complete_block_timeout: 1m
      nodeSelector:
        nodeTypeClass: observability

    distributor:
      replicas: 1
      resources:
        limits:
          cpu: 200m
          memory: 1024Mi
        requests:
          cpu: 100m
          memory: 512Mi   
      nodeSelector:
        nodeTypeClass: observability   
    
    queryFrontend:      
      replicas: 1
      resources:
        limits:
          cpu: 100m
          memory: 256Mi
        requests:
          cpu: 50m
          memory: 128Mi
      nodeSelector:
        nodeTypeClass: observability
      service:
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
          service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "60"
          service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
          service.beta.kubernetes.io/aws-load-balancer-type: nlb-ip
          service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags: Environment=${var.environment}
          service.beta.kubernetes.io/aws-load-balancer-scheme: "internal"

    querier:
      replicas: 1
      resources:
        limits:
          cpu: 300m
          memory: 1024Mi
        requests:
          cpu: 100m
          memory: 512Mi
      nodeSelector:
        nodeTypeClass: observability

    traces:
      otlp:
        grpc:
          enabled: true
        http:
          enabled: true

    storage:
      trace:
        backend: s3
        s3:
          bucket: infra-platos-tempo-${var.environment}
          endpoint: s3.dualstack.us-east-1.amazonaws.com
          access_key: ${var.aws_access_key_id}
          secret_key: ${var.aws_secret_access_key}
          region: us-east-1
    EOT
  ]
}