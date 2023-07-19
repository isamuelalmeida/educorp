resource "kubernetes_ingress_v1" "front_lite_ingress" {
  count = contains(["production", "stage"], var.environment) ? 1 : 0

  metadata {
    name      = "front-lite-ingress"
    namespace = "front-lite"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "front_lite")
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"          = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"     = "instance"
      "kubernetes.io/ingress.class"               = "alb"
    }
  }

  spec {
    rule {
      host = "kroton.${var.domain}"

      http {
        path {
          path      = "/lite"
          path_type = "Prefix"

          backend {
            service {
              name = "front-lite"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
