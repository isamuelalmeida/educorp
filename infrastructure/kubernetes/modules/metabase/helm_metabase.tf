resource "helm_release" "metabase" {
  atomic = true

  repository = "https://pmint93.github.io/helm-charts"

  name  = "metabase"
  chart = "metabase"

  version = "v1.2.0"

  namespace        = "metabase"
  create_namespace = true

  values = [<<-EOT
    service:
      type: NodePort
    database:
      type: postgres      
      port: 5432
      dbname: ${var.metabase_database_dbname}
      username: ${var.metabase_database_username}
      password: ${var.metabase_database_password}
      host: ${var.metabase_database_host}

    extraInitContainers:
      - name: download-modules
        image: "curlimages/curl:7.70.0"
        imagePullPolicy: "IfNotPresent"
        volumeMounts:
          - name: plugins
            mountPath: /plugins
        workingDir: /plugins
        command:
          - "/bin/sh"
          - "-ec"
          - |
            curl -Lso /plugins/athena.metabase-driver.jar \
                      https://github.com/dacort/metabase-athena-driver/releases/download/v1.2.1/athena.metabase-driver.jar

    extraVolumeMounts:
      - name: plugins
        mountPath: /plugins
        readOnly: false

    extraVolumes:
      - name: plugins
        emptyDir: {}

    nodeSelector:
      nodeTypeClass: tools

    resources:
      limits:
        cpu: 500m
        memory: 1500Mi
      requests:
        cpu: 100m
        memory: 1024Mi

  EOT
  ]
}
