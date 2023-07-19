#Docs: https://oauth2-proxy.github.io/oauth2-proxy/docs/
resource "helm_release" "hermes_oauth2_proxy" {
  atomic = true

  name       = "hermes-oauth2-proxy"
  repository = "https://oauth2-proxy.github.io/manifests"

  chart   = "oauth2-proxy"
  version = "v6.5.0"

  namespace        = "kafka"
  create_namespace = true

  set {
    name  = "config.clientID"
    value = var.keycloak_hermes_oauth2proxy_oidc_client_id
  }

  set {
    name  = "config.clientSecret"
    value = var.keycloak_hermes_oauth2proxy_oidc_client_secret
  }

  set {
    name  = "config.cookieSecret"
    value = data.aws_ssm_parameter.oauth2proxy_cookie_secret.value
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "config.configFile"
    value = <<-EOT
      email_domains = [ "*" ]
      upstreams = [ "http://hermes-management.kafka" ]
      provider = "keycloak"
      login_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}/protocol/openid-connect/auth"
      redeem_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}/protocol/openid-connect/token"
      profile_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}/protocol/openid-connect/userinfo"
      validate_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}/protocol/openid-connect/userinfo"
      scope = "email"
      allowed_groups = [ "hermes" ]
    EOT
  }

  values = [<<-EOT
    nodeSelector:
      nodeTypeClass: microservices

  EOT
  ]
}

resource "helm_release" "kafdrop_oauth2_proxy" {
  atomic = true

  name       = "kafdrop-oauth2-proxy"
  repository = "https://oauth2-proxy.github.io/manifests"

  chart   = "oauth2-proxy"
  version = "v6.5.0"

  namespace        = "kafka"
  create_namespace = true

  set {
    name  = "config.clientID"
    value = var.keycloak_kafdrop_oauth2proxy_oidc_client_id
  }

  set {
    name  = "config.clientSecret"
    value = var.keycloak_kafdrop_oauth2proxy_oidc_client_secret
  }

  set {
    name  = "config.cookieSecret"
    value = data.aws_ssm_parameter.oauth2proxy_cookie_secret.value
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "config.configFile"
    value = <<-EOT
      email_domains = [ "*" ]
      upstreams = [ "http://kafdrop.kafka" ]
      provider = "keycloak"
      login_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}/protocol/openid-connect/auth"
      redeem_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}/protocol/openid-connect/token"
      profile_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}/protocol/openid-connect/userinfo"
      validate_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}/protocol/openid-connect/userinfo"
      scope = "email"
      allowed_groups = [ "kafka" ]
    EOT
  }

  values = [<<-EOT
    nodeSelector:
      nodeTypeClass: microservices

  EOT
  ]

}