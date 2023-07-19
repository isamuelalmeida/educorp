# resource "keycloak_openid_client" "tenant_openid_client" {
#   count = contains(["dev"], terraform.workspace) ? length(var.tenants) : 0

#   realm_id  = keycloak_realm.tenant_realm[count.index].id
#   client_id = "${keycloak_realm.tenant_realm[count.index].realm}-api"

#   name    = "${keycloak_realm.tenant_realm[count.index].realm}-api"
#   enabled = true

#   description = "OpenID Client para conceder acesso externo as nossas API's"

#   access_type = "CONFIDENTIAL"

#   standard_flow_enabled = false

#   direct_access_grants_enabled = false

#   service_accounts_enabled = true
# }
