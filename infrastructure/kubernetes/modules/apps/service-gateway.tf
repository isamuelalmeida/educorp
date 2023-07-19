resource "kubernetes_ingress_v1" "service_gateway_ingress" {

  # count = contains(["stage"], var.environment) ? 1 : 0
  count = 0
  
  metadata {
    name      = "service-gateway-ingress"
    namespace = "service-gateway"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "service_gateway")
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
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "service-gateway"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "umc.${var.domain}"

      http {
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "service-gateway"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "upf.${var.domain}"

      http {
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "service-gateway"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "utp.${var.domain}"

      http {
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "service-gateway"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "demo.${var.domain}"

      http {
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "service-gateway"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "unopar.${var.domain}"

      http {
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "service-gateway"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "anhanguera.${var.domain}"

      http {
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "service-gateway"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "haoc.${var.domain}"

      http {
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "service-gateway"

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
