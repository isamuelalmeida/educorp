data "terraform_remote_state" "baseline" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "infra-cognalabs-terraform-state"
    key    = "infra-cognalabs-baseline.tfstate"
    region = "us-east-1"
    profile = "educorp_prod"
  }
}

data "terraform_remote_state" "iam" {
  workspace = terraform.workspace == "dev" ? terraform.workspace : "production"
  backend = "s3"
  config = {
    bucket = "infra-cognalabs-terraform-state"
    key    = "infra-cognalabs-iam.tfstate"
    region = "us-east-1"
    profile = "educorp_prod"
  }
}