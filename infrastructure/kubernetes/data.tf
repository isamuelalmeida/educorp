data "terraform_remote_state" "eks" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "infra-cognalabs-terraform-state"
    key    = "infra-cognalabs-eks.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "baseline" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "infra-cognalabs-terraform-state"
    key    = "infra-cognalabs-baseline.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "infra-cognalabs-terraform-state"
    key    = "infra-cognalabs-iam.tfstate"
    region = "us-east-1"
  }
}

## Postgres Exporter
data "aws_ssm_parameter" "cosmos_monitoring_database_username" {
  name = "/${terraform.workspace}/monitoring/cosmos_database_username"
}

data "aws_ssm_parameter" "cosmos_monitoring_database_password" {
  name = "/${terraform.workspace}/monitoring/cosmos_database_password"
}