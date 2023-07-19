module "env_info" {
  source = "../../modules-terraform/env_info"
}

variable "tags" {
  type = map(string)
  default = {
    "Terraform" = "true"
  }
}

variable "node_group_name_by_env" {
  default = {
    dev        = "cosmos-eks-dev"
    stage      = "cosmos-eks-stg"
    production = "cosmos-eks-prd"
  }
}