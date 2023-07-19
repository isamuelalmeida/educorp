resource "kubernetes_ingress_v1" "frontend_sag_kroton_ingress" {
  metadata {
    name      = "frontend-sag-ingress"
    namespace = "kroton"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "frontend_sag_kroton")
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"          = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"     = "instance"
      "kubernetes.io/ingress.class"               = "alb"
    }
  }

  spec {
    rule {
      host = "sag-kroton.${var.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "frontend-sag"

              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "sag_service_kroton_ingress" {
  metadata {
    name      = "sag-service-ingress"
    namespace = "kroton"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
      "alb.ingress.kubernetes.io/certificate-arn"  = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"       = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"      = lookup(var.ingress_group_orders, "sag_service_kroton")
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"           = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"      = "instance"
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/health_check"
    }
  }

  spec {
    rule {
      host = "sag-api-kroton.${var.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "sag-service"

              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }
}