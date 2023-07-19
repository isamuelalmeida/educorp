# resource "keycloak_openid_client" "service_order_openid_client" {
#   count = contains(["dev"], terraform.workspace) ? length(var.tenants) : 0

#   realm_id = keycloak_realm.tenant_realm[count.index].id

#   client_id = "service-order"

#   name    = "service-order"
#   enabled = true

#   description = "OpenID Client para conceder acesso ao Service Order"

#   access_type = "CONFIDENTIAL"

#   standard_flow_enabled = false

#   direct_access_grants_enabled = false

#   service_accounts_enabled = true
# }
