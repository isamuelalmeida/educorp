variable "keycloak_hermes_oauth2proxy_oidc_client_id" {
  type = string
}

variable "keycloak_hermes_oauth2proxy_oidc_client_secret" {
  type = string
}

variable "keycloak_kafdrop_oauth2proxy_oidc_client_id" {
  type = string
}

variable "keycloak_kafdrop_oauth2proxy_oidc_client_secret" {
  type = string
}

variable "domain" {
  type = string
}

variable "keycloak_realm" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "ingress_group_name" {
  type = string
}

variable "hermes_ingress_group_order" {
  type = string
}

variable "kafdrop_ingress_group_order" {
  type = string
}

variable "ingress_scheme" {
  type = string
}

variable "auth_url_path" {
  type = string
}