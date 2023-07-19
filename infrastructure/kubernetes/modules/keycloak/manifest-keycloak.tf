# Source: keycloak/templates/serviceaccount.yaml
resource "kubernetes_service_account" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "keycloak"
    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "keycloak"
    }
  }
  automount_service_account_token = false
}

# Source: keycloak/templates/secrets.yaml
resource "kubernetes_secret" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "keycloak"
    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "keycloak"
    }
  }
  type = "Opaque"
  # As secrets estão codificadas em base64
  data = {
    "admin-password"      = var.keycloak_admin_password
    "management-password" = var.keycloak_management_password
    "postgresql-password" = var.keycloak_database_password
  }
}

# Source: keycloak/templates/configmap-env-vars.yaml
resource "kubernetes_config_map" "keycloak_env_vars" {
  metadata {
    name      = "keycloak-env-vars"
    namespace = "keycloak"
    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "keycloak"
    }
  }

  data = {
    KEYCLOAK_CREATE_ADMIN_USER : "true"
    KEYCLOAK_ADMIN_USER : var.keycloak_admin_username
    KEYCLOAK_MANAGEMENT_USER : "manager"
    KEYCLOAK_HTTP_PORT : "8080"
    KEYCLOAK_PROXY_ADDRESS_FORWARDING : "true"
    KEYCLOAK_ENABLE_STATISTICS : "true"
    KEYCLOAK_DATABASE_HOST : var.keycloak_database_host
    KEYCLOAK_DATABASE_PORT : "5432"
    KEYCLOAK_DATABASE_NAME : var.keycloak_database_dbname
    KEYCLOAK_DATABASE_USER : var.keycloak_database_username
    KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL : "kubernetes.KUBE_PING"
    KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES : ""
    KEYCLOAK_JGROUPS_TRANSPORT_STACK : "tcp"
    KEYCLOAK_CACHE_OWNERS_COUNT : "1"
    KEYCLOAK_AUTH_CACHE_OWNERS_COUNT : "1"
    KEYCLOAK_ENABLE_TLS : "false"
  }
}

# Source: keycloak/templates/role.yaml
resource "kubernetes_role" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "keycloak"
    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "keycloak"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list"]
  }
}

# Source: keycloak/templates/rolebinding.yaml
resource "kubernetes_role_binding" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "keycloak"

    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "keycloak"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "keycloak"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "keycloak"
    namespace = "keycloak"
  }
}

# Source: keycloak/templates/headless-service.yaml
resource "kubernetes_service" "keycloak_headless" {
  metadata {
    name      = "keycloak-headless"
    namespace = "keycloak"

    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "keycloak"
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/name"      = "keycloak"
      "app.kubernetes.io/instance"  = "keycloak"
      "app.kubernetes.io/component" = "keycloak"
    }

    type       = "ClusterIP"
    cluster_ip = "None"

    port {
      name        = "http"
      port        = 80
      target_port = "http"
      protocol    = "TCP"
    }

    publish_not_ready_addresses = true
  }
}

# Source: keycloak/templates/metrics-service.yaml
resource "kubernetes_service" "keycloak_metrics" {
  metadata {
    name      = "keycloak-metrics"
    namespace = "keycloak"

    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "metrics"
    }

    annotations = {
      "prometheus.io/port"   = "9990"
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/name"      = "keycloak"
      "app.kubernetes.io/instance"  = "keycloak"
      "app.kubernetes.io/component" = "keycloak"
    }

    port {
      name        = "http-management"
      port        = 9990
      target_port = 9990
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Source: keycloak/templates/service.yaml
resource "kubernetes_service" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "keycloak"

    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "keycloak"
    }
  }

  spec {
    type                    = "NodePort"
    external_traffic_policy = "Cluster"

    port {
      name        = "http"
      port        = 80
      target_port = "http"
      protocol    = "TCP"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "https"
      protocol    = "TCP"
    }

    selector = {
      "app.kubernetes.io/name"      = "keycloak"
      "app.kubernetes.io/instance"  = "keycloak"
      "app.kubernetes.io/component" = "keycloak"
    }
  }
}


# Source: keycloak/templates/statefulset.yaml
resource "kubernetes_stateful_set" "keycloak" {
  depends_on = [
    kubernetes_service_account.keycloak,
    kubernetes_secret.keycloak,
    kubernetes_config_map.keycloak_env_vars,
    kubernetes_role.keycloak,
    kubernetes_role_binding.keycloak,
    kubernetes_service.keycloak_headless,
    kubernetes_service.keycloak_metrics,
    kubernetes_service.keycloak
  ]

  timeouts {
    create = "2m"
  }

  metadata {
    name      = "keycloak"
    namespace = "keycloak"

    labels = {
      "app.kubernetes.io/name"       = "keycloak"
      "helm.sh/chart"                = "keycloak-6.1.0"
      "app.kubernetes.io/instance"   = "keycloak"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/component"  = "keycloak"
    }
  }

  spec {
    replicas = var.keycloak_replica_count

    pod_management_policy = "Parallel"

    service_name = "keycloak-headless"

    update_strategy {
      type = "RollingUpdate"
    }

    selector {
      match_labels = {
        "app.kubernetes.io/name"      = "keycloak"
        "app.kubernetes.io/instance"  = "keycloak"
        "app.kubernetes.io/component" = "keycloak"
      }
    }

    template {
      metadata {
        annotations = {
          "checksum/configmap-env-vars" = "977bbc910126df0f55c66773711d3b17086aaf630f0354196b3e5bafed011c7a"
          "checksum/secrets"            = "ffb088700dc650e9e0611f7506f7838c06a85d821003fa10cd06018b3d0bad3c"
        }

        labels = {
          "app.kubernetes.io/name"       = "keycloak"
          "helm.sh/chart"                = "keycloak-6.1.0"
          "app.kubernetes.io/instance"   = "keycloak"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/component"  = "keycloak"
        }
      }

      spec {
        service_account_name = "keycloak"

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/name"     = "keycloak"
                    "app.kubernetes.io/instance" = "keycloak"
                  }
                }
                namespaces   = ["keycloak"]
                topology_key = "kubernetes.io/hostname"
              }
              weight = 1
            }
          }
        }

        security_context {
          fs_group = 1001
        }

        init_container {
          name              = "theme-provider"
          image             = "registry.gitlab.com/platosedu/cosmos/keycloak-themes:421932836"
          image_pull_policy = "Always"
          command           = ["sh"]
          args              = ["-c", "echo 'copying themes...'; chmod 777 /theme-front-indica-app; cp -R /keycloak-themes/themes/front-indica-app/* /theme-front-indica-app; chmod 777 /theme-digitalfinance; cp -R /keycloak-themes/themes/digitalfinance/* /theme-digitalfinance; chmod 777 /theme-admin-ecomm; cp -R /keycloak-themes/themes/admin-ecomm/* /theme-admin-ecomm;"]

          volume_mount {
            name       = "theme-front-indica-app"
            mount_path = "/theme-front-indica-app"
          }
          volume_mount {
            name       = "theme-digitalfinance"
            mount_path = "/theme-digitalfinance"
          }
          volume_mount {
            name       = "theme-admin-ecomm"
            mount_path = "/theme-admin-ecomm"
          }
        }

        container {
          name              = "keycloak"
          image             = "docker.io/bitnami/keycloak:16.1.0-debian-10-r0"
          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_non_root = true
            run_as_user     = 1001
          }

          env {
            name = "KUBERNETES_NAMESPACE"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }

          env {
            name  = "BITNAMI_DEBUG"
            value = "false"
          }

          env {
            name = "KEYCLOAK_ADMIN_PASSWORD"
            value_from {
              secret_key_ref {
                name = "keycloak"
                key  = "admin-password"
              }
            }
          }

          env {
            name = "KEYCLOAK_MANAGEMENT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "keycloak"
                key  = "management-password"
              }
            }
          }

          env {
            name = "KEYCLOAK_DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "keycloak"
                key  = "postgresql-password"
              }
            }
          }

          env_from {
            config_map_ref {
              name = "keycloak-env-vars"
            }
          }

          port {
            name           = "http"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "https"
            container_port = 8443
            protocol       = "TCP"
          }

          port {
            name           = "http-management"
            container_port = 9990
            protocol       = "TCP"
          }

          liveness_probe {
            failure_threshold = 3

            http_get {
              path = "/auth/"
              port = "http"
            }

            initial_delay_seconds = 300
            period_seconds        = 1
            success_threshold     = 1
            timeout_seconds       = 5
          }

          readiness_probe {
            failure_threshold = 3

            http_get {
              path = "/auth/realms/master"
              port = "http"
            }

            initial_delay_seconds = 30
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }

          volume_mount {
            name       = "theme-front-indica-app"
            mount_path = "/opt/bitnami/keycloak/themes/front-indica-app"
          }
          volume_mount {
            name       = "theme-digitalfinance"
            mount_path = "/opt/bitnami/keycloak/themes/digitalfinance"
          }
          volume_mount {
            name       = "theme-admin-ecomm"
            mount_path = "/opt/bitnami/keycloak/themes/admin-ecomm"
          }
          
          resources {
            requests = {
              cpu = "100m"
              memory = "512Mi"
            }
            limits = {
              cpu = "1500m"
              memory = "1024Mi"
            }
          }

        }

        node_selector = {
          nodeTypeClass = "tools"
        }

        volume {
          name = "theme-front-indica-app"
          empty_dir {}
        }
        volume {
          name = "theme-digitalfinance"
          empty_dir {}
        }
        volume {
          name = "theme-admin-ecomm"
          empty_dir {}
        }

      }
    }
  }
}