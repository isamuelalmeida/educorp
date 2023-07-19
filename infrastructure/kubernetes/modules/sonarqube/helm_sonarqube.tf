resource "helm_release" "sonarqube" {
  atomic = true

  name       = "sonarqube"
  repository = "https://SonarSource.github.io/helm-chart-sonarqube"

  chart   = "sonarqube"
  version = "8.0.1+546"

  namespace        = "sonarqube"
  create_namespace = true

  values = [<<-EOT
nodeSelector:
  nodeTypeClass: tools
service:
  type: NodePort
sonarProperties:
  sonar.core.serverBaseURL: https://sonarqube.${var.domain}
plugins:
  install:
    - "https://github.com/vaulttec/sonar-auth-oidc/releases/download/v2.1.1/sonar-auth-oidc-plugin-2.1.1.jar"
postgresql:
  enabled: false
  postgresqlServer: ${var.database_hostname}
  postgresqlDatabase: ${var.database_name}
  postgresqlUsername: ${var.database_username}
  postgresqlPassword: ${var.database_password}
EOT
  ]
}