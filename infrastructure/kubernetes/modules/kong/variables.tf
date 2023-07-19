variable "certificate_arn" {
  type = string
}

variable "replica_count" {
  type = number
}

variable "resources" {
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
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