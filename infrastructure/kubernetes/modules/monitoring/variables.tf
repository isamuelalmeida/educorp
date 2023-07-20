variable "environment" {
  type = string
}

variable "cosmos_monitoring_database_username" {
  type      = string
  sensitive = true
}

variable "cosmos_monitoring_database_password" {
  type      = string
  sensitive = true
}

variable "cosmos_database_instance_address" {
  type      = string
  sensitive = true
}
