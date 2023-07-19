# https://keda.sh/docs/2.7/deploy/#install-2
resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"

  chart   = "keda"
  version = "2.7.1"

  namespace        = "keda"
  create_namespace = true

  values = [<<-EOT
nodeSelector:
  nodeTypeClass: tools
resources:
  operator:
    limits:
      cpu: 500m
      memory: 500Mi
    requests:
      cpu: 50m
      memory: 100Mi
  metricServer:
    limits:
      cpu: 100m
      memory: 200Mi
    requests:
      cpu: 50m
      memory: 100Mi
EOT
  ]
}
