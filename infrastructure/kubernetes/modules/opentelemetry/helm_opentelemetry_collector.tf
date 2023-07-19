resource "helm_release" "opentelemetry_collector" {
  depends_on = [ helm_release.opentelemetry_operator ]

  atomic = true

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"

  name    = "opentelemetry-collector"
  chart   = "opentelemetry-collector"
  version = "0.62.2"

  namespace        = "observability"
  create_namespace = true

  values = [<<-EOT

    fullnameOverride: "agent-traces"

    mode: deployment

    replicaCount: 1

    presets:
      logsCollection:
        enabled: false
      hostMetrics:
        enabled: false
      kubernetesAttributes:
        enabled: false
      kubeletMetrics:
        enabled: false

    ports:
      otlp:
        enabled: true
      otlp-http:
        enabled: true
      jaeger-compact:
        enabled: false
      jaeger-thrift:
        enabled: false
      jaeger-grpc:
        enabled: false
      zipkin:
        enabled: false
      metrics:
        enabled: false

    config:
      receivers:
        jaeger: null
        zipkin: null
        otlp:
          protocols:
            grpc:
              endpoint: 0.0.0.0:4317
            http:
              endpoint: 0.0.0.0:4318
        prometheus:
          config:
            scrape_configs:
            - job_name: 'otel-collector'
              scrape_interval: 30s
              static_configs:
              - targets: ['0.0.0.0:8888']
      processors:
        memory_limiter:
          check_interval: 1s
          limit_percentage: 75
          spike_limit_percentage: 15
        batch:
          send_batch_size: 10000
          timeout: 10s
      exporters:
        otlp:
          endpoint: "http://tempo-distributor.grafana:4317"
          tls:
            insecure: true
        prometheusremotewrite/prometheus:
          endpoint: "http://prometheus-operated.prometheus:9090/api/v1/write"
        logging:
          loglevel: debug
      service:
        telemetry:
          metrics:
            address: localhost:8888
        pipelines:
          traces:
            receivers: [otlp]
            processors: [memory_limiter, batch]
            exporters: [otlp]
          metrics:
            receivers: [otlp]
            processors: [memory_limiter, batch]
            exporters: [prometheusremotewrite/prometheus]
          logs:
            receivers: [otlp]
            processors: [memory_limiter, batch]
            exporters: [logging]

    nodeSelector:
      nodeTypeClass: observability

    resources:
      limits:
        cpu: 300m
        memory: 2Gi
      requests:
        cpu: 100m
        memory: 200Mi

    EOT
  ]

}