variable "vault_database_dbname" {
  type = string
}

variable "vault_database_host" {
  type = string
}

variable "vault_database_username" {
  type = string
}

variable "vault_database_password" {
  type = string
}

variable "vault_kms_access_key_id" {
  type = string
}

variable "vault_kms_secret_access_key" {
  type = string
}

variable "vault_kms_region" {
  type = string
}

variable "vault_kms_key_id" {
  type = string
}

variable "vault_ha_replica_count" {
  type = number
}

variable "vault_injector_replica_count" {
  type = number
}

variable "keycloak_vault_oidc_client_id" {
  type = string
}

variable "keycloak_vault_oidc_client_secret" {
  type = string
}

variable "keycloak_realm" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "domain" {
  type = string
}

variable "kubernetes_ca_cert" {
  type = string
}

variable "kubernetes_api_server_endpoint" {
  type = string
}

variable "ingress_group_name" {
  type = string
}

variable "ingress_group_order" {
  type = string
}

variable "ingress_scheme" {
  type = string
}

variable "auth_url_path" {
  type = string
}