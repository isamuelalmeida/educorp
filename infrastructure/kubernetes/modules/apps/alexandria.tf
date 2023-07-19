resource "kubernetes_ingress_v1" "frontend_alexandria_kroton_ingress" {
  metadata {
    name      = "frontend-alexandria-ingress"
    namespace = "kroton"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "frontend_alexandria_kroton")
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"          = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"     = "instance"
      "kubernetes.io/ingress.class"               = "alb"
    }
  }

  spec {
    rule {
      host = "cms-kroton.${var.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "frontend-alexandria"

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

resource "kubernetes_ingress_v1" "alexandria_service_kroton_ingress" {
  metadata {
    name      = "alexandria-service-ingress"
    namespace = "kroton"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
      "alb.ingress.kubernetes.io/certificate-arn"  = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"       = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"      = lookup(var.ingress_group_orders, "alexandria_service_kroton")
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"           = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"      = "instance"
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/health_check"
    }
  }

  spec {
    rule {
      host = "cms-api-kroton.${var.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "alexandria-service"

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