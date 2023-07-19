resource "keycloak_openid_client" "hermes_oauth2proxy_openid_client" {
  realm_id  = keycloak_realm.realm.id
  client_id = "hermes"

  name    = "hermes"
  enabled = true

  standard_flow_enabled = true

  direct_access_grants_enabled = true

  access_type = "CONFIDENTIAL"
  valid_redirect_uris = [
    "https://hermes.${var.domain}/oauth2/callback"
  ]

  root_url    = "https://hermes.${var.domain}"
  admin_url   = "https://hermes.${var.domain}"
  web_origins = ["https://hermes.${var.domain}"]

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_openid_group_membership_protocol_mapper" "hermes_oauth2proxy_role_mapper" {
  realm_id   = keycloak_realm.realm.id
  client_id  = keycloak_openid_client.hermes_oauth2proxy_openid_client[count.index].id
  name       = "groups"
  claim_name = "groups"

  full_path           = false
  add_to_id_token     = true
  add_to_access_token = false
  add_to_userinfo     = true

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}