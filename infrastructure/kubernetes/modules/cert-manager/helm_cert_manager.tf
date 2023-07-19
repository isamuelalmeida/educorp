resource "helm_release" "cert_manager" {

  atomic = true

  repository = "https://charts.jetstack.io"

  name    = "cert-manager"
  chart   = "cert-manager"
  version = "1.12.2"

  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "prometheus.enabled"
    value = "false"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

}