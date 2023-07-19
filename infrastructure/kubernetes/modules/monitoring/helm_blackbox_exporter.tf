resource "helm_release" "blackbox_exporter" {
  atomic = true

  repository = "https://prometheus-community.github.io/helm-charts"

  name    = "prometheus-blackbox-exporter"
  chart   = "prometheus-blackbox-exporter"
  version = "7.6.1"

  namespace = "prometheus"

  values = [<<-EOT
    nodeSelector:
      nodeTypeClass: observability

  EOT
  ]
}