resource "keycloak_openid_client" "cosmos_openid_client" {
  realm_id  = "kroton"
  client_id = "cosmos"

  name    = "cosmos"
  enabled = true

  description = "OpenID Client para conceder acesso ao Cosmos"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled = false

  direct_access_grants_enabled = false

  service_accounts_enabled = true

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}