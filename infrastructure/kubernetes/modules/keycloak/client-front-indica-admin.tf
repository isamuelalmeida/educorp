# resource "keycloak_openid_client" "openid_client_front_indica_admin" {
#   count = contains(["dev"], terraform.workspace) ? length(var.tenants) : 0

#   realm_id  = keycloak_realm.tenant_realm[count.index].id
#   client_id = "front-indica-admin"

#   name    = "front-indica-admin"
#   enabled = true

#   description = "OpenID Client para o front-indica-admin"

#   access_type = "PUBLIC"

#   standard_flow_enabled = true

#   direct_access_grants_enabled = true

#   valid_redirect_uris = [
#     "*"
#   ]

#   web_origins = [
#     "*"
#   ]
# }

# resource "keycloak_role" "realm_role_front_indica_admin" {
#   count = contains(["dev"], terraform.workspace) ? length(var.tenants) : 0
#   realm_id    = keycloak_realm.tenant_realm[count.index].id
#   client_id   = keycloak_openid_client.openid_client_front_indica_admin[count.index].id
#   name        = "ROLE_INDICA_ADMIN"
#   description = "Role responsável por liberar o acesso ao admin do indica"
# }
