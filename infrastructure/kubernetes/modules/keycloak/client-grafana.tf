resource "keycloak_openid_client" "grafana_openid_client" {
  realm_id  = keycloak_realm.realm.id
  client_id = "grafana"

  name    = "grafana"
  enabled = true

  standard_flow_enabled = true

  direct_access_grants_enabled = true

  access_type = "CONFIDENTIAL"
  valid_redirect_uris = [
    "https://grafana.${var.domain}/login/generic_oauth"
  ]

  count = contains(["dev"], terraform.workspace) ? 1 : 0

}

resource "keycloak_role" "grafana_admin_role" {
  realm_id  = keycloak_realm.realm.id
  name      = "Admin"
  client_id = keycloak_openid_client.grafana_openid_client[count.index].id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_role" "grafana_editor_role" {
  realm_id  = keycloak_realm.realm.id
  name      = "Editor"
  client_id = keycloak_openid_client.grafana_openid_client[count.index].id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_role" "grafana_viewer_role" {
  realm_id  = keycloak_realm.realm.id
  name      = "Viewer"
  client_id = keycloak_openid_client.grafana_openid_client[count.index].id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}

resource "keycloak_openid_user_client_role_protocol_mapper" "user_client_role_mapper" {
  realm_id                    = keycloak_realm.realm.id
  client_id                   = keycloak_openid_client.grafana_openid_client[count.index].id
  name                        = "user-client-role-mapper"
  claim_name                  = "resource_access.${keycloak_openid_client.grafana_openid_client[count.index].client_id}.roles"
  multivalued                 = true
  client_id_for_role_mappings = keycloak_openid_client.grafana_openid_client[count.index].client_id

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}