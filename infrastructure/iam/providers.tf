terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-iam.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.15.1"
    }
  }
}

provider "aws" {
  region = module.env_info.envs[terraform.workspace].region

  assume_role {
    role_arn = module.env_info.envs.aws_role_arn_by_env[terraform.workspace]
  }

  default_tags {
    tags = merge(
      module.env_info.envs.default_tags,
      { "estagio" = module.env_info.envs.default_tag_estagio_by_env[terraform.workspace] }
    )
  }
}
