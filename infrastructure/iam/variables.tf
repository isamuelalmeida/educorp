module "env_info" {
  source = "../../modules-terraform/env_info"
}

variable "tags" {
  type = map(string)
  default = {
    "Terraform" = "true"
  }
}

locals {
  files    = fileset("${path.module}/policies", "*")
  accounts = { for k, v in local.files : replace(k, ".json", "") => v }
}