resource "keycloak_openid_client" "backstage_openid_client" {
  realm_id  = keycloak_realm.realm.id
  client_id = "backstage"

  name    = "backstage"
  enabled = true

  standard_flow_enabled = true

  direct_access_grants_enabled = true

  access_type = "CONFIDENTIAL"
  valid_redirect_uris = [
    "https://labs.${var.domain}/*"
  ]

  count = contains(["dev"], terraform.workspace) ? 1 : 0
}
