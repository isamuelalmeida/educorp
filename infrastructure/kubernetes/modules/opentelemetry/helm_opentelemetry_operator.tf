resource "helm_release" "opentelemetry_operator" {

  atomic = true

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"

  name    = "opentelemetry-operator"
  chart   = "opentelemetry-operator"
  version = "0.33.0"

  namespace        = "observability"
  create_namespace = true

  set {
    name  = "runners.nodeSelector.nodeTypeClass"
    value = "observability"
  }

}