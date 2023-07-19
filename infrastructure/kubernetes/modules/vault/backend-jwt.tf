resource "vault_jwt_auth_backend" "gitlab_jwt_auth_backend" {
  path         = "jwt"
  type         = "jwt"
  jwks_url     = "https://gitlab.com/-/jwks"
  bound_issuer = "gitlab.com"
}