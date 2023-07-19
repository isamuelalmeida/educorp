data "terraform_remote_state" "baseline" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-baseline.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "iam" {
  workspace = terraform.workspace == "production" ? terraform.workspace : "default"
  backend = "s3"
  config = {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-iam.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpn" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-vpn.tfstate"
    region = "us-east-1"
  }
}