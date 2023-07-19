# resource "keycloak_openid_client" "openid_client_front_indica_app" {
#   count = contains(["dev"], terraform.workspace) ? length(var.tenants) : 0

#   realm_id  = keycloak_realm.tenant_realm[count.index].id
#   client_id = "front-indica-app"

#   name    = "front-indica-app"
#   enabled = true

#   description = "OpenID Client para o aplicativo de indicação do front-indica-app"

#   access_type = "PUBLIC"

#   standard_flow_enabled = true

#   direct_access_grants_enabled = true

#   valid_redirect_uris = [
#     "*"
#   ]

#   web_origins = [
#     "*"
#   ]

#   login_theme = "front-indica-app"

#   access_token_lifespan = "600"
# }

# resource "keycloak_role" "realm_role_front_indica_app" {
#   count = contains(["dev"], terraform.workspace) ? length(var.tenants) : 0

#   realm_id    = keycloak_realm.tenant_realm[count.index].id
#   client_id   = keycloak_openid_client.openid_client_front_indica_app[count.index].id
#   name        = "ROLE_INDICA_APP"
#   description = "Role responsável por liberar o acesso ao app do indica"
# }
