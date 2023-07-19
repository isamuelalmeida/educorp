resource "keycloak_openid_client" "sonarqube_openid_client" {
  realm_id  = keycloak_realm.realm.id
  client_id = "sonarqube"

  name    = "sonarqube"
  enabled = true

  standard_flow_enabled = true

  direct_access_grants_enabled = true

  access_type = "CONFIDENTIAL"
  valid_redirect_uris = [
    "https://sonarqube.${var.domain}/oauth2/callback/oidc"
  ]

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_role" "sonarqube_admin_role" {
  realm_id  = keycloak_realm.realm.id
  name      = "sonar-administrators"
  client_id = keycloak_openid_client.sonarqube_openid_client[count.index].id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_role" "sonarqube_user_role" {
  realm_id  = keycloak_realm.realm.id
  name      = "sonar-users"
  client_id = keycloak_openid_client.sonarqube_openid_client[count.index].id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_openid_group_membership_protocol_mapper" "sonarqube_role_mapper" {
  realm_id   = keycloak_realm.realm.id
  client_id  = keycloak_openid_client.sonarqube_openid_client[count.index].id
  name       = "groups"
  claim_name = "groups"

  full_path           = false
  add_to_id_token     = true
  add_to_access_token = false
  add_to_userinfo     = true

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}