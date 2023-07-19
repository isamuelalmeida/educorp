resource "vault_identity_oidc_key" "keycloak_provider_key" {
  name      = "keycloak"
  algorithm = "RS256"
}

#vault write auth/oidc/config \
#         oidc_discovery_url="https://sso.<domain>/realms/cosmos" \
#         oidc_client_id="vault" \
#         oidc_client_secret="<secret>" \
#         default_role="user"
resource "vault_jwt_auth_backend" "keycloak_auth_backend" {
  path               = "oidc"
  type               = "oidc"
  default_role       = "user"
  oidc_discovery_url = "https://sso.${var.domain}/${var.auth_url_path}realms/${var.keycloak_realm}"
  oidc_client_id     = var.keycloak_vault_oidc_client_id
  oidc_client_secret = var.keycloak_vault_oidc_client_secret

  tune {
    audit_non_hmac_request_keys  = []
    audit_non_hmac_response_keys = []
    default_lease_ttl            = "1h"
    listing_visibility           = "unauth"
    max_lease_ttl                = "1h"
    passthrough_request_headers  = []
    token_type                   = "default-service"
  }
}

# vault write auth/oidc/role/user bound_audiences="vault" \
#           allowed_redirect_uris="https://vault.<domain>/ui/vault/auth/oidc/oidc/callback" \
#           user_claim="sub" \
#           policies="user" \
#           groups_claim="/resource_access/vault/roles"
resource "vault_jwt_auth_backend_role" "user" {
  backend   = vault_jwt_auth_backend.keycloak_auth_backend.path
  role_name = "user"
  role_type = "oidc"

  bound_audiences = [var.keycloak_vault_oidc_client_id]
  user_claim      = "sub"
  token_policies  = ["user"]

  allowed_redirect_uris = ["https://vault.${var.domain}/ui/vault/auth/oidc/oidc/callback"]
  groups_claim          = "/resource_access/${var.keycloak_vault_oidc_client_id}/roles"
}

# vault write auth/oidc/role/admin bound_audiences="vault" \
#           allowed_redirect_uris="https://vault.<domain>/ui/vault/auth/oidc/oidc/callback" \
#           user_claim="sub" \
#           policies="admin" \
#           groups_claim="/resource_access/vault/roles"
resource "vault_jwt_auth_backend_role" "admin" {
  backend   = vault_jwt_auth_backend.keycloak_auth_backend.path
  role_name = "admin"
  role_type = "oidc"

  bound_audiences = [var.keycloak_vault_oidc_client_id]
  user_claim      = "sub"
  token_policies  = ["admin"]

  allowed_redirect_uris = ["https://vault.${var.domain}/ui/vault/auth/oidc/oidc/callback"]
  groups_claim          = "/resource_access/${var.keycloak_vault_oidc_client_id}/roles"
}