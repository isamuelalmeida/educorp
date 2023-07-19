resource "helm_release" "kong_gateway" {
  atomic = true

  repository = "https://charts.konghq.com"

  name             = "kong"
  chart            = "kong"
  namespace        = "kong"
  create_namespace = true
  version          = "2.16.5"

  values = [<<-EOT
env:
  trusted_ips: 0.0.0.0/0,::/0
proxy:
  enabled: true
  type: NodePort
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: alb
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ${var.certificate_arn}
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
    service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
replicaCount: ${var.replica_count}
nodeSelector:
  nodeTypeClass: microservices
fullnameOverride: kong
resources:
  limits:
    cpu: ${var.resources.limits.cpu}
    memory: ${var.resources.limits.memory}
  requests:
    cpu: ${var.resources.requests.cpu}
    memory: ${var.resources.requests.memory}
EOT
  ]
}