data "terraform_remote_state" "eks" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-eks.tfstate"
    region = "us-east-1"
  }
}

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
  backend = "s3"
  config = {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-iam.tfstate"
    region = "us-east-1"
  }
}

## Grafana
data "aws_ssm_parameter" "grafana_admin_password" {
  name = "/${terraform.workspace}/grafana_admin_password"
}

data "aws_ssm_parameter" "grafana_database_host" {
  name = "/${terraform.workspace}/grafana_database_host"
}

data "aws_ssm_parameter" "grafana_database_username" {
  name = "/${terraform.workspace}/grafana_database_username"
}

data "aws_ssm_parameter" "grafana_database_password" {
  name = "/${terraform.workspace}/grafana_database_password"
}

## Keycloak
data "aws_ssm_parameter" "keycloak_admin_username" {
  name = "/${terraform.workspace}/keycloak_admin_username"
}

data "aws_ssm_parameter" "keycloak_admin_password" {
  name = "/${terraform.workspace}/keycloak_admin_password"
}

data "aws_ssm_parameter" "keycloak_management_password" {
  name = "/${terraform.workspace}/keycloak_management_password"
}

data "aws_ssm_parameter" "keycloak_database_host" {
  name = "/${terraform.workspace}/keycloak_database_host"
}

data "aws_ssm_parameter" "keycloak_database_username" {
  name = "/${terraform.workspace}/keycloak_database_username"
}

data "aws_ssm_parameter" "keycloak_database_password" {
  name = "/${terraform.workspace}/keycloak_database_password"
}

data "aws_ssm_parameter" "keycloak_smtp_server_username" {
  name = "/keycloak_smtp_server_username"
}

data "aws_ssm_parameter" "keycloak_smtp_server_password" {
  name = "/keycloak_smtp_server_password"
}

## Keycloak (Client ID and Secret)
data "aws_ssm_parameter" "keycloak_terraform_client_id" {
  name = "/${terraform.workspace}/keycloak_terraform_client_id"
}

data "aws_ssm_parameter" "keycloak_terraform_client_secret" {
  name = "/${terraform.workspace}/keycloak_terraform_client_secret"
}

data "aws_ssm_parameter" "keycloak_vault_oidc_client_id" {
  name = "/${terraform.workspace}/keycloak_vault_oidc_client_id"
}

data "aws_ssm_parameter" "keycloak_vault_oidc_client_secret" {
  name = "/${terraform.workspace}/keycloak_vault_oidc_client_secret"
}

data "aws_ssm_parameter" "keycloak_grafana_oidc_client_id" {
  name = "/${terraform.workspace}/keycloak_grafana_oidc_client_id"
}

data "aws_ssm_parameter" "keycloak_grafana_oidc_client_secret" {
  name = "/${terraform.workspace}/keycloak_grafana_oidc_client_secret"
}

data "aws_ssm_parameter" "keycloak_hermes_oauth2proxy_oidc_client_id" {
  name = "/${terraform.workspace}/keycloak_hermes_oauth2proxy_oidc_client_id"
}

data "aws_ssm_parameter" "keycloak_hermes_oauth2proxy_oidc_client_secret" {
  name = "/${terraform.workspace}/keycloak_hermes_oauth2proxy_oidc_client_secret"
}

data "aws_ssm_parameter" "keycloak_kafdrop_oauth2proxy_oidc_client_id" {
  name = "/${terraform.workspace}/keycloak_kafdrop_oauth2proxy_oidc_client_id"
}

data "aws_ssm_parameter" "keycloak_kafdrop_oauth2proxy_oidc_client_secret" {
  name = "/${terraform.workspace}/keycloak_kafdrop_oauth2proxy_oidc_client_secret"
}

## Vault
data "aws_ssm_parameter" "vault_database_host" {
  name = "/${terraform.workspace}/vault_database_host"
}

data "aws_ssm_parameter" "vault_database_username" {
  name = "/${terraform.workspace}/vault_database_username"
}

data "aws_ssm_parameter" "vault_database_password" {
  name = "/${terraform.workspace}/vault_database_password"
}

data "aws_ssm_parameter" "vault_kms_access_key_id" {
  name = "/vault_kms_access_key_id"
}

data "aws_ssm_parameter" "vault_kms_secret_access_key" {
  name = "/vault_kms_secret_access_key"
}

data "aws_ssm_parameter" "vault_cluster_keys" {
  name = "/${terraform.workspace}/vault_cluster_keys"
}

locals {
  vault_cluster_keys = jsondecode(data.aws_ssm_parameter.vault_cluster_keys.value)
}

## Metabase
data "aws_ssm_parameter" "metabase_database_username" {
  name = "/${terraform.workspace}/metabase_database_username"
}

data "aws_ssm_parameter" "metabase_database_password" {
  name = "/${terraform.workspace}/metabase_database_password"
}

## Postgres Exporter
data "aws_ssm_parameter" "cosmos_monitoring_database_username" {
  name = "/${terraform.workspace}/monitoring/cosmos_database_username"
}

data "aws_ssm_parameter" "cosmos_monitoring_database_password" {
  name = "/${terraform.workspace}/monitoring/cosmos_database_password"
}

## Gitlab Token
data "aws_ssm_parameter" "prometheus_gitlab_token" {
  name = "/prometheus_gitlab_token"
}

## Cosmos para Metabase
data "aws_ssm_parameter" "cosmos_database_host" {
  name = "/${terraform.workspace}/cosmos_database_host"
}

## Chave para stack do Grafana
data "aws_ssm_parameter" "infra_platos_s3_access_key_id" {
  name = "/infra_platos_s3_access_key_id"
}

data "aws_ssm_parameter" "infra_platos_s3_secret_access_key" {
  name = "/infra_platos_s3_secret_access_key"
}

## Sonarqube
data "aws_ssm_parameter" "sonarqube_database_hostname" {
  name = "/${terraform.workspace}/sonarqube_database_hostname"
}

data "aws_ssm_parameter" "sonarqube_database_name" {
  name = "/${terraform.workspace}/sonarqube_database_name"
}

data "aws_ssm_parameter" "sonarqube_database_username" {
  name = "/${terraform.workspace}/sonarqube_database_username"
}

data "aws_ssm_parameter" "sonarqube_database_password" {
  name = "/${terraform.workspace}/sonarqube_database_password"
}