variable "domain" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "grafana_admin_password" {
  type = string
}

variable "grafana_database_host" {
  type = string
}

variable "grafana_database_name" {
  type = string
}

variable "grafana_database_username" {
  type = string
}

variable "grafana_database_password" {
  type = string
}

variable "keycloak_grafana_oidc_client_id" {
  type = string
}

variable "keycloak_grafana_oidc_client_secret" {
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
