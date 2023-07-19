terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "infra-cognalabs-terraform-state"
    key    = "infra-cognalabs-baseline.tfstate"
    region = "us-east-1"
    profile = "operator"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  region = module.env_info.envs[terraform.workspace].region

  profile = module.env_info.envs[terraform.workspace].profile

  default_tags {
    tags = merge(
      module.env_info.envs.default_tags,
      { "estagio" = module.env_info.envs.default_tag_estagio_by_env[terraform.workspace] }
    )
  }
}
