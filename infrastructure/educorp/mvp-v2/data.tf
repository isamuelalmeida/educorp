data "terraform_remote_state" "baseline" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-baseline.tfstate"
    region = "us-east-1"
  }
}

resource "random_password" "rds_password" {
  length   = 40
  special  = false
  for_each = local.customers.envs[terraform.workspace]
}

resource "random_password" "wordpress_password" {
  length   = 30
  special  = true
  for_each = local.customers.envs[terraform.workspace]
}

resource "aws_ssm_parameter" "educorp_database_password" {
  for_each = local.customers.envs[terraform.workspace]
  name     = "/${terraform.workspace}/educorp_${each.key}_database_password"
  type     = "SecureString"
  value    = random_password.rds_password[each.key].result
}

resource "aws_ssm_parameter" "educorp_database_username" {
  for_each  = local.customers.envs[terraform.workspace]
  name      = "/${terraform.workspace}/educorp_${each.key}_database_username"
  type      = "SecureString"
  value     = each.key
  overwrite = true
}

resource "aws_ssm_parameter" "educorp_wp_password" {
  for_each = local.customers.envs[terraform.workspace]
  name     = "/${terraform.workspace}/educorp_${each.key}_wp_password"
  type     = "SecureString"
  value    = random_password.wordpress_password[each.key].result
}