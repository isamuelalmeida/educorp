resource "keycloak_openid_client" "admin_ecomm_openid_client" {
  realm_id  = keycloak_realm.realm.id
  client_id = "admin-ecomm"

  name    = "admin-ecomm"
  enabled = true

  description = "OpenID Client para o front de gerencimento do ecomm"

  access_type = "PUBLIC"

  standard_flow_enabled = true

  direct_access_grants_enabled = true

  login_theme = "admin-ecomm"

  valid_redirect_uris = [
    "*"
  ]

  web_origins = [
    "*",
  ]

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_role" "realm_role_front_admin_ecomm" {
  realm_id    = keycloak_realm.realm.id
  client_id   = keycloak_openid_client.admin_ecomm_openid_client[count.index].id
  name        = "ROLE_ADMIN_ECOMM"
  description = "Role responsável por liberar o acesso de admin ao admin-ecomm"

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_generic_client_protocol_mapper" "admin_ecomm_protocol_mapper" {
  realm_id        = keycloak_realm.realm.id
  client_id       = keycloak_openid_client.admin_ecomm_openid_client[count.index].id
  name            = "client role"
  protocol        = "openid-connect"
  protocol_mapper = "oidc-usermodel-client-role-mapper"
  config = {
    "access.token.claim"                   = "true"
    "claim.name"                           = "roles"
    "id.token.claim"                       = "false"
    "jsonType.label"                       = "String"
    "multivalued"                          = "true"
    "userinfo.token.claim"                 = "false"
    "usermodel.clientRoleMapping.clientId" = null
  }

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}