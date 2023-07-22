module "env_info" {
  source = "../../../modules-terraform/env_info"
}

variable "tag_name" {
  default = "educorp-wp-prd"
}