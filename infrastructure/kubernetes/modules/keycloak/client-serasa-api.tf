# resource "keycloak_openid_client" "serasa_openid_client" {
#   realm_id  = keycloak_realm.tenant_realm[0].id
#   client_id = "serasa-api"

#   name    = "serasa-api"
#   enabled = true

#   description = "OpenID Client para conceder acesso externo as nossas API's ao Serasa"

#   access_type = "CONFIDENTIAL"

#   standard_flow_enabled = false

#   direct_access_grants_enabled = false

#   service_accounts_enabled = true

#   count = contains(["dev"], terraform.workspace) ? 1 : 0
# }
