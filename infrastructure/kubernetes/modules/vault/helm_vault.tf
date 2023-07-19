resource "helm_release" "vault" {
  atomic = true

  repository = "https://helm.releases.hashicorp.com"

  name    = "vault"
  chart   = "vault"
  version = "0.23.0"

  namespace        = "vault"
  create_namespace = true

  values = [<<-EOT
    server:
      priorityClassName: "system-cluster-critical"
      annotations:
        karpenter.sh/do-not-evict: "true"
      service:
        type: NodePort      
      ha:
        enabled: true
        replicas: ${var.vault_ha_replica_count}
        disruptionBudget:
          enabled: true
          maxUnavailable: 1
        config: |
          disable_mlock = true
          ui = true

          listener "tcp" {
            tls_disable = 1
            address = "[::]:8200"
            cluster_address = "[::]:8201"
          }
          storage "mysql" {
            address  = "${var.vault_database_host}"
            database = "${var.vault_database_dbname}"
            username = "${var.vault_database_username}"
            password = "${var.vault_database_password}"
            ha_enabled = "true"
          }
          seal "awskms" {
            region = "${var.vault_kms_region}"
            access_key = "${var.vault_kms_access_key_id}"
            secret_key = "${var.vault_kms_secret_access_key}"
            kms_key_id = "${var.vault_kms_key_id}"
          }
          telemetry {
            disable_hostname = true
            prometheus_retention_time = "12h"
          }
      resources:
        requests:
          memory: 128Mi
          cpu: 100m
        limits:
          memory: 1Gi
          cpu: 500m
      nodeSelector:
        nodeTypeClass: tools

    injector:
      replicas: ${var.vault_injector_replica_count}
      enabled: true
      logLevel: "debug"
      metrics:
        enabled: true
      resources:
        requests:
          memory: 64Mi
          cpu: 25m
        limits:
          memory: 256Mi
          cpu: 50m
      nodeSelector:
        nodeTypeClass: tools
        
  EOT
  ]
}