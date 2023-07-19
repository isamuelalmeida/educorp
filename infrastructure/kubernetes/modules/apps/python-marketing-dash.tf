resource "kubernetes_ingress_v1" "python_marketing_dash_ingress" {
  count = contains(["stage"], var.environment) ? 0 : 1

  metadata {
    name      = "python-marketing-dash-ingress"
    namespace = "python-marketing-dash"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "python_marketing_dash")
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
          path      = "/python-marketing-dash"
          path_type = "Prefix"

          backend {
            service {
              name = "python-marketing-dash"

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
