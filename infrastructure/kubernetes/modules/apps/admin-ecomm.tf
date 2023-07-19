resource "kubernetes_ingress_v1" "admin_ecomm_ingress" {
  metadata {
    name      = "admin-ecomm-ingress"
    namespace = "admin-ecomm"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "admin_ecomm")
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"          = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"     = "instance"
      "kubernetes.io/ingress.class"               = "alb"
    }
  }

  spec {
    rule {
      host = "admin-ecomm.${var.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "admin-ecomm"

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