resource "kubernetes_ingress_v1" "metabase_ingress" {
  depends_on = [
    helm_release.metabase
  ]

  metadata {
    name      = "metabase-ingress"
    namespace = "metabase"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = var.ingress_group_order
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"          = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"     = "instance"
      "kubernetes.io/ingress.class"               = "alb"
    }
  }

  spec {
    rule {
      host = "metabase.${var.domain}"

      http {
        path {
          path      = "/*"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = "metabase"

              port {
                number = 80
              }
            }
          }
        }

        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "metabase"

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