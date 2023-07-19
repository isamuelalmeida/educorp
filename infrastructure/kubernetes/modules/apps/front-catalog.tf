resource "kubernetes_ingress_v1" "front_catalog_ingress" {
  metadata {
    name      = "front-catalog-ingress"
    namespace = "front-catalog"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "front_catalog")
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
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "front-catalog"

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
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "front-catalog"

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
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "front-catalog"

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
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "front-catalog"

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
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "front-catalog"

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
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "front-catalog"

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
