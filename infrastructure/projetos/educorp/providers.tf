terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "infra-cognalabs-terraform-state"
    key    = "infra-cognalabs-educorp.tfstate"
    region = "us-east-1"
    profile = "educorp_prod"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}

provider "aws" {
  region = module.env_info.envs[terraform.workspace].region

  assume_role {
    role_arn = module.env_info.envs[terraform.workspace].aws_provider_role_arn
  }

  default_tags {
    tags = merge(
      local.default_tags,
      { "estagio" = module.env_info.envs.default_tag_estagio_by_env[terraform.workspace] }
    )
  }
}