resource "kubernetes_manifest" "auto_instrumentation" {
  depends_on = [ helm_release.opentelemetry_collector ]

  for_each = var.namespace_instrumentation

  manifest = {
    apiVersion = "opentelemetry.io/v1alpha1"
    kind       = "Instrumentation"
    metadata = {
      name      = "auto-instrumentation"
      namespace = each.value.namespace
    }

    spec = {
      exporter = {
        endpoint = "http://agent-traces.observability:4317"
      }

      propagators = ["tracecontext", "baggage"]

      sampler = {
        type     = "parentbased_traceidratio"
        argument = each.value.sampler
      }

      java = {
        image = "ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-java:1.26.0"
        env = [
          {
            name  = "OTEL_LOGS_EXPORTER"
            value = "none"
          },
          {
            name  = "OTEL_METRICS_EXPORTER"
            value = "otlp"
          },
          {
            name  = "OTEL_INSTRUMENTATION_COMMON_DB_STATEMENT_SANITIZER_ENABLED"
            value = "false"
          },
          {
            name  = "OTEL_INSTRUMENTATION_RUNTIME_METRICS_ENABLED"
            value = "true"
          },
          {
            name  = "OTEL_INSTRUMENTATION_COMMON_PEER_SERVICE_MAPPING"
            value = "true"
          },
          {
            name  = "OTEL_INSTRUMENTATION_KAFKA_EXPERIMENTAL_SPAN_ATTRIBUTES"
            value = "true"
          }
        ]
      }

      nodejs = {
        image = "ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-nodejs:0.39.1"
        env = [
          {
            name  = "OTEL_LOGS_EXPORTER"
            value = "none"
          }
        ]
      }

      python = {
        image = "ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-python:0.39b0"
        env = [
          {
            name  = "OTEL_LOGS_EXPORTER"
            value = "none"
          }
        ]
      }
    }
  }
}
