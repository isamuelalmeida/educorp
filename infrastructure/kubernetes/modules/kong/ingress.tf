resource "kubernetes_ingress_v1" "kong_proxy_ingress" {
  depends_on = [
    helm_release.kong_gateway
  ]

  metadata {
    name      = "kong-proxy-ingress"
    namespace = "kong"

    annotations = {
      "kubernetes.io/ingress.class"                    = "alb"
      "konghq.com/preserve-host"                       = "true"
      "alb.ingress.kubernetes.io/ssl-redirect"         = "443"
      "alb.ingress.kubernetes.io/certificate-arn"      = var.certificate_arn
      "alb.ingress.kubernetes.io/group.name"           = var.ingress_group_name
      "alb.ingress.kubernetes.io/group.order"          = var.ingress_group_order
      "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"               = var.ingress_scheme
      "alb.ingress.kubernetes.io/target-type"          = "instance"
      "alb.ingress.kubernetes.io/healthcheck-path"     = "/healthz"
      "alb.ingress.kubernetes.io/healthcheck-port"     = "10254"
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/ssl-policy"           = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
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
              name = "kong-proxy"

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
              name = "kong-proxy"

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
              name = "kong-proxy"

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
              name = "kong-proxy"

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
              name = "kong-proxy"

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
              name = "kong-proxy"

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
              name = "kong-proxy"

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
              name = "kong-proxy"

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
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = "kong-proxy"

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

locals {
  services = [
    "spring-demo",
    "service-payment",
    "service-indica",
    "service-product",
    "service-pricing",
    "service-promotion",
    "service-order",
    "service-cms",
    "service-crm",
    "service-lead",
    "service-docs",
    "service-catalog",
    "service-progress",
    "service-debtnegotiation",
    "service-digitalfinance",
    "service-bankslip",
    "service-opm-externo",
    "service-enrollment",
    "service-openai"
  ]
}

resource "kubernetes_manifest" "kong_plugin_cors_microservices" {
  
  depends_on = [
    kubernetes_ingress_v1.service_kong_ingress
  ]

  for_each = toset(local.services)

  manifest = {
    apiVersion = "configuration.konghq.com/v1"
    kind       = "KongPlugin"
    metadata = {
      name = "cors-microservices"
      namespace = each.value
    }
    config = {
      origins = ["*"]
      headers = ["*"]
      exposed_headers = ["X-Auth-Token", "tenantid", "authorization"]
      credentials    = true
      max_age        = 3600
      preflight_continue = false
    }
    plugin = "cors"
  }
}


resource "kubernetes_ingress_v1" "service_kong_ingress" {
  depends_on = [kubernetes_ingress_v1.kong_proxy_ingress]

  for_each = { for s in local.services : s => s }

  wait_for_load_balancer = true
  metadata {
    name      = "${each.value}-kong-ingress"
    namespace = each.value

    annotations = {
      "konghq.com/protocols"                  = "https"
      "konghq.com/https-redirect-status-code" = "308"
      "konghq.com/strip-path"                 = "true"
      "konghq.com/preserve-host"              = "true"
      "konghq.com/plugins"                    = "cors-microservices"
      "konghq.com/methods"                    = "GET,POST,OPTIONS,HEAD,PUT,PATCH,DELETE,TRACE,CONNECT"
    }
  }
  spec {
    ingress_class_name = "kong"
    rule {
      http {
        path {
          path      = "/api/${each.value}"
          path_type = "Prefix"
          backend {
            service {
              name = each.value
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

resource "kubernetes_ingress_v1" "cosmos_login_ingress" {
  depends_on = [kubernetes_ingress_v1.kong_proxy_ingress]

  wait_for_load_balancer = true
  metadata {
    name      = "cosmos-login-kong-ingress"
    namespace = "cosmos"

    annotations = {
      "konghq.com/protocols"                  = "https"
      "konghq.com/https-redirect-status-code" = "308"
      "konghq.com/strip-path"                 = "true"
      "konghq.com/preserve-host"              = "true"
      "konghq.com/plugins"                    = "request-transformer-cosmos-login"
      "konghq.com/methods"                    = "GET,POST,OPTIONS,HEAD,PUT,PATCH,DELETE,TRACE,CONNECT"
    }
  }
  spec {
    ingress_class_name = "kong"
    rule {
      http {
        path {
          path      = "/api/login"
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