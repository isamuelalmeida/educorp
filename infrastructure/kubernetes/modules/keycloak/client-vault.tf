resource "keycloak_openid_client" "vault_openid_client" {
  realm_id  = keycloak_realm.realm.id
  client_id = "vault"

  name    = "vault"
  enabled = true

  standard_flow_enabled = true

  direct_access_grants_enabled = true

  access_type = "CONFIDENTIAL"
  valid_redirect_uris = [
    "https://vault.${var.domain}/ui/vault/auth/oidc/oidc/callback"
  ]

  root_url    = "https://vault.${var.domain}"
  base_url    = "/ui/vault/auth?with=oidc"
  admin_url   = "https://vault.${var.domain}"
  web_origins = ["https://vault.${var.domain}"]

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_role" "vault_admin_role" {
  realm_id  = keycloak_realm.realm.id
  name      = "admin"
  client_id = keycloak_openid_client.vault_openid_client[count.index].id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_role" "vault_user_role" {
  realm_id  = keycloak_realm.realm.id
  name      = "user"
  client_id = keycloak_openid_client.vault_openid_client[count.index].id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_openid_user_client_role_protocol_mapper" "vault_user_client_role_mapper" {
  realm_id                    = keycloak_realm.realm.id
  client_id                   = keycloak_openid_client.vault_openid_client[count.index].id
  name                        = "user-client-role-mapper"
  claim_name                  = "resource_access.${keycloak_openid_client.vault_openid_client[count.index].client_id}.roles"
  multivalued                 = true
  client_id_for_role_mappings = keycloak_openid_client.vault_openid_client[count.index].client_id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}