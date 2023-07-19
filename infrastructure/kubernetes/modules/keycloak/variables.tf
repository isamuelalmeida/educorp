variable "tenants" {
  description = "Tenants Platos"
  type        = list(string)
  default = [
    "kroton",
    "upf",
    "utp",
    "umc",
    "unopar",
    "anhanguera",
    "haoc"
  ]
}

variable "keycloak_admin_username" {
  type = string
}

variable "keycloak_admin_password" {
  type = string
}

variable "keycloak_management_password" {
  type = string
}

variable "keycloak_database_dbname" {
  type = string
}

variable "keycloak_database_host" {
  type = string
}

variable "keycloak_database_username" {
  type = string
}

variable "keycloak_database_password" {
  type = string
}

variable "keycloak_smtp_server_from" {
  type = string
}

variable "keycloak_smtp_server_from_display_name" {
  type = string
}

variable "keycloak_smtp_server_host" {
  type = string
}

variable "keycloak_smtp_server_username" {
  type = string
}

variable "keycloak_smtp_server_password" {
  type = string
}

variable "keycloak_platos_realm" {
  type = string
}

variable "keycloak_replica_count" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "domain" {
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