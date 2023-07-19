module "env_info" {
  source = "../../modules-terraform/env_info"
}

variable "tags" {
  type = map(string)
  default = {
    "Terraform" = "true"
  }
}
