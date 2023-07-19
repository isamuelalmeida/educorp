resource "kubernetes_ingress_v1" "cosmos_erp_ingress" {
  metadata {
    name      = "cosmos-erp-ingress"
    namespace = "cosmos"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "cosmos_erp")
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
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

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
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

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
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

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
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

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
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "cta.${var.domain}"

      http {
        path {
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "infoprod.${var.domain}"

      http {
        path {
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "mackenzie.${var.domain}"

      http {
        path {
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

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
          path      = "/erp"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-erp"

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

resource "kubernetes_ingress_v1" "cosmos_lms_ingress" {
  metadata {
    name      = "cosmos-lms-ingress"
    namespace = "cosmos"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "cosmos_lms")
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
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

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
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

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
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

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
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

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
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "cta.${var.domain}"

      http {
        path {
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "infoprod.${var.domain}"

      http {
        path {
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "mackenzie.${var.domain}"

      http {
        path {
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

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
          path      = "/lms"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-lms"

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

resource "kubernetes_ingress_v1" "cosmos_rest_ingress" {
  metadata {
    name      = "cosmos-rest-ingress"
    namespace = "cosmos"

    annotations = {
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"     = lookup(var.ingress_group_orders, "cosmos_rest")
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
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

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
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

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
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

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
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

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
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "cta.${var.domain}"

      http {
        path {
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "infoprod.${var.domain}"

      http {
        path {
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "mackenzie.${var.domain}"

      http {
        path {
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

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
          path      = "/rest"
          path_type = "Prefix"

          backend {
            service {
              name = "cosmos-rest"

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