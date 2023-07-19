# resource "keycloak_openid_client" "front_digitalfinance_openid_client" {
#   count = contains(["dev"], terraform.workspace) ? length(var.tenants) : 0

#   realm_id  = keycloak_realm.tenant_realm[count.index].id
#   client_id = "front-digitalfinance"

#   name    = "front-digitalfinance"
#   enabled = true

#   description = "OpenID Client para o front-digitalfinance"

#   access_type = "PUBLIC"

#   standard_flow_enabled = true

#   direct_access_grants_enabled = true

#   valid_redirect_uris = [
#     "*"
#   ]

#   web_origins = [
#     "*"
#   ]

#   login_theme = "digitalfinance"
# }
