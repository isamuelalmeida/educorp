variable "environment" {
  type = string
}

variable "prometheus_gitlab_token" {
  type      = string
  sensitive = true
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

variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}