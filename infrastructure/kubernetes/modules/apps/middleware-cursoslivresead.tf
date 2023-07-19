resource "kubernetes_ingress_v1" "middleware_cursoslivresead_ingress" {
  count = contains(["production", "stage"], var.environment) ? 1 : 0

  metadata {
    name      = "middleware-cursoslivresead-ingress"
    namespace = "middleware"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "middleware_cursoslivresead")
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"          = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"     = "instance"
      "kubernetes.io/ingress.class"               = "alb"
    }
  }

  spec {
    rule {
      host = "middleware-cursoslivresead.${var.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "middleware-cursoslivresead"

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
