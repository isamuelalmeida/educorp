# resource "helm_release" "keycloak" {
#   atomic = true

#   repository = "https://charts.bitnami.com/bitnami"

#   name             = "keycloak"
#   chart            = "keycloak"
#   namespace        = "keycloak"
#   create_namespace = true
#   version          = terraform.workspace == "dev" ? "6.1.0" : "9.8.1" # Recomendado atualizar da versão 6.1 para 9.2, após isso, pula para 9.8

#   set {
#     name  = "postgresql.enabled"
#     value = false
#   }

#   set {
#     name  = "auth.adminUser"
#     value = var.keycloak_admin_username
#   }

#   set {
#     name  = "auth.adminPassword"
#     value = var.keycloak_admin_password
#   }

#   set {
#     name  = "externalDatabase.host"
#     value = var.keycloak_database_host
#   }

#   set {
#     name  = "externalDatabase.database"
#     value = var.keycloak_database_dbname
#   }

#   set {
#     name  = "externalDatabase.user"
#     value = var.keycloak_database_username
#   }

#   set {
#     name  = "externalDatabase.password"
#     value = var.keycloak_database_password
#   }

#   set {
#     name  = "service.type"
#     value = "NodePort"
#   }

#   set {
#     name  = "proxyAddressForwarding"
#     value = "true"
#   }

#   set {
#     name  = "metrics.enabled"
#     value = "true"
#   }

#   set {
#     name  = "replicaCount"
#     value = var.keycloak_replica_count
#   }

#   set {
#     name  = "serviceDiscovery.enabled"
#     value = "true"
#   }

#   set {
#     name  = "rbac.create"
#     value = "true"
#   }

#   set {
#     name  = "httpRelativePath"
#     value = "/"
#   }

#   set {
#     name  = "initContainers"
#     value = <<-EOT
#       - name: theme-provider
#         image: registry.gitlab.com/platosedu/cosmos/keycloak-themes:421932836
#         imagePullPolicy: Always
#         command:
#           - sh
#         args:
#           - -c
#           - |
#             echo "copying themes..."
#             chmod 777 /theme-front-indica-app
#             cp -R /keycloak-themes/themes/front-indica-app/* /theme-front-indica-app
#             chmod 777 /theme-digitalfinance
#             cp -R /keycloak-themes/themes/digitalfinance/* /theme-digitalfinance
#             chmod 777 /theme-admin-ecomm
#             cp -R /keycloak-themes/themes/admin-ecomm/* /theme-admin-ecomm
#         volumeMounts:
#           - name: theme-front-indica-app
#             mountPath: /theme-front-indica-app
#           - name: theme-digitalfinance
#             mountPath: /theme-digitalfinance
#           - name: theme-admin-ecomm
#             mountPath: /theme-admin-ecomm
#     EOT
#   }

#   set {
#     name  = "extraVolumeMounts"
#     value = <<-EOT
#       - name: theme-front-indica-app
#         mountPath: /opt/bitnami/keycloak/themes/front-indica-app
#       - name: theme-digitalfinance
#         mountPath: /opt/bitnami/keycloak/themes/digitalfinance
#       - name: theme-admin-ecomm
#         mountPath: /opt/bitnami/keycloak/themes/admin-ecomm
#     EOT
#   }

#   set {
#     name  = "extraVolumes"
#     value = <<-EOT
#       - name: theme-front-indica-app
#         emptyDir: {}
#       - name: theme-digitalfinance
#         emptyDir: {}
#       - name: theme-admin-ecomm
#         emptyDir: {}
#     EOT
#   }
# }
