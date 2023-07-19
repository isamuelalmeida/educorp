terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-educorp-v2.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}

provider "aws" {
  region = local.envs[terraform.workspace].region

  assume_role {
    role_arn = local.envs.aws_role_arn
  }

  default_tags {
    tags = merge(
      local.envs.default_tags,
      { "estagio" = local.envs.default_tag_estagio_by_env[terraform.workspace] }
    )
  }
}