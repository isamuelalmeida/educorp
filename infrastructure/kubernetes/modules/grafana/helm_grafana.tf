resource "helm_release" "grafana" {
  atomic = true

  repository = "https://grafana.github.io/helm-charts"

  name             = "grafana"
  chart            = "grafana"
  version          = "6.56.6"
  namespace        = "grafana"
  create_namespace = true

  values = [<<-EOT
    service:
      type: NodePort

    nodeSelector:
      nodeTypeClass: tools
      
    adminPassword: ${var.grafana_admin_password}

    grafana.ini:
      database:
        type: postgres
        name: ${var.grafana_database_name}
        host: ${var.grafana_database_host}
        user: ${var.grafana_database_username}
        password: ${var.grafana_database_password}
      server:
        root_url: https://grafana.${var.domain}
      auth:
        signout_redirect_url: https://sso.${var.domain}/${var.auth_url_path}realms/platos/protocol/openid-connect/logout
      auth.generic_oauth:
        name: Platos
        enabled: true
        allow_sign_up: true
        client_id: ${var.keycloak_grafana_oidc_client_id}
        client_secret: ${var.keycloak_grafana_oidc_client_secret}
        scopes: openid profile email
        role_attribute_path: contains(resource_access.grafana.roles[*], 'Admin') && 'Admin' || contains(resource_access.grafana.roles[*], 'Editor') && 'Editor' || 'Viewer'
        auth_url: https://sso.${var.domain}/${var.auth_url_path}realms/platos/protocol/openid-connect/auth
        token_url: https://sso.${var.domain}/${var.auth_url_path}realms/platos/protocol/openid-connect/token
        api_url: https://sso.${var.domain}/${var.auth_url_path}realms/platos/protocol/openid-connect/userinfo
      feature_toggles:
        enable: tempoSearch tempoBackendSearch tempoApmTable publicDashboards traceqlEditor
    
    resources:
      limits:
        cpu: 200m
        memory: 512Mi
      requests:
        cpu: 50m
        memory: 128Mi
    EOT
  ]
}