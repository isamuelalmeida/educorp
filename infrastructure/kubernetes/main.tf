module "monitoring" {
  source = "./modules/monitoring"

  environment = module.env_info.envs[terraform.workspace].environment

  aws_access_key_id     = data.aws_ssm_parameter.infra_platos_s3_access_key_id.value
  aws_secret_access_key = data.aws_ssm_parameter.infra_platos_s3_secret_access_key.value

  prometheus_gitlab_token             = data.aws_ssm_parameter.prometheus_gitlab_token.value
  cosmos_monitoring_database_username = data.aws_ssm_parameter.cosmos_monitoring_database_username.value
  cosmos_monitoring_database_password = data.aws_ssm_parameter.cosmos_monitoring_database_password.value
  cosmos_database_instance_address    = data.aws_ssm_parameter.cosmos_database_host.value
}

module "load_balancer_controller" {
  source = "./modules/load-balancer-controller"

  vpc_id       = data.terraform_remote_state.baseline.outputs.vpc_id
  cluster_name = module.env_info.envs[terraform.workspace].eks.cluster_name
  region       = module.env_info.envs[terraform.workspace].region
  role_arn     = data.terraform_remote_state.eks.outputs.eks_load_balancer_controller_role_arn
}

module "keycloak" {
  source = "./modules/keycloak"

  keycloak_admin_username      = data.aws_ssm_parameter.keycloak_admin_username.value
  keycloak_admin_password      = data.aws_ssm_parameter.keycloak_admin_password.value
  keycloak_management_password = data.aws_ssm_parameter.keycloak_management_password.value

  keycloak_database_dbname   = module.env_info.envs[terraform.workspace].keycloak.database.dbname
  keycloak_database_host     = data.aws_ssm_parameter.keycloak_database_host.value
  keycloak_database_username = data.aws_ssm_parameter.keycloak_database_username.value
  keycloak_database_password = data.aws_ssm_parameter.keycloak_database_password.value

  keycloak_smtp_server_from              = module.env_info.envs[terraform.workspace].keycloak.smtpServer.from
  keycloak_smtp_server_from_display_name = module.env_info.envs[terraform.workspace].keycloak.smtpServer.fromDisplayName
  keycloak_smtp_server_host              = module.env_info.envs[terraform.workspace].keycloak.smtpServer.host
  keycloak_smtp_server_username          = data.aws_ssm_parameter.keycloak_smtp_server_username.value
  keycloak_smtp_server_password          = data.aws_ssm_parameter.keycloak_smtp_server_password.value

  keycloak_platos_realm  = module.env_info.envs[terraform.workspace].keycloak.platos_realm
  keycloak_replica_count = module.env_info.envs[terraform.workspace].keycloak.replica_count

  certificate_arn = module.env_info.envs[terraform.workspace].certificate_arn
  domain          = module.env_info.envs[terraform.workspace].domain

  ingress_group_name  = module.env_info.envs[terraform.workspace].keycloak.ingress.group_name
  ingress_group_order = lookup(module.env_info.envs.alb.ingress.group_orders, "keycloak")
  ingress_scheme      = module.env_info.envs[terraform.workspace].keycloak.ingress.scheme
}

module "vault" {
  source = "./modules/vault"

  vault_database_dbname   = module.env_info.envs[terraform.workspace].vault.database.dbname
  vault_database_host     = data.aws_ssm_parameter.vault_database_host.value
  vault_database_username = data.aws_ssm_parameter.vault_database_username.value
  vault_database_password = data.aws_ssm_parameter.vault_database_password.value

  vault_kms_region             = module.env_info.envs[terraform.workspace].region
  vault_kms_access_key_id      = data.aws_ssm_parameter.vault_kms_access_key_id.value
  vault_kms_secret_access_key  = data.aws_ssm_parameter.vault_kms_secret_access_key.value
  vault_kms_key_id             = data.terraform_remote_state.baseline.outputs.aws_vault_kms_key_id
  vault_ha_replica_count       = module.env_info.envs[terraform.workspace].vault.ha.replica_count
  vault_injector_replica_count = module.env_info.envs[terraform.workspace].vault.injector.replica_count

  keycloak_vault_oidc_client_id     = data.aws_ssm_parameter.keycloak_vault_oidc_client_id.value
  keycloak_vault_oidc_client_secret = data.aws_ssm_parameter.keycloak_vault_oidc_client_secret.value
  keycloak_realm                    = module.keycloak.keycloak_platos_realm

  certificate_arn = module.env_info.envs[terraform.workspace].certificate_arn
  domain          = module.env_info.envs[terraform.workspace].domain

  kubernetes_ca_cert             = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  kubernetes_api_server_endpoint = data.aws_eks_cluster.cluster.endpoint

  ingress_group_name  = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "${module.env_info.envs[terraform.workspace].eks.cluster_name}-internal" : module.env_info.envs[terraform.workspace].eks.cluster_name
  ingress_group_order = lookup(module.env_info.envs.alb.ingress.group_orders, "vault")
  ingress_scheme      = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "internal" : "internet-facing"

  auth_url_path = module.env_info.envs[terraform.workspace].keycloak.auth_url_path

  depends_on = [
    module.keycloak
  ]
}

module "grafana" {
  source = "./modules/grafana"

  certificate_arn = module.env_info.envs[terraform.workspace].certificate_arn
  domain          = module.env_info.envs[terraform.workspace].domain
  environment     = module.env_info.envs[terraform.workspace].environment

  grafana_admin_password    = data.aws_ssm_parameter.grafana_admin_password.value
  grafana_database_host     = data.aws_ssm_parameter.grafana_database_host.value
  grafana_database_name     = module.env_info.envs[terraform.workspace].grafana.database.dbname
  grafana_database_username = data.aws_ssm_parameter.grafana_database_username.value
  grafana_database_password = data.aws_ssm_parameter.grafana_database_password.value

  keycloak_grafana_oidc_client_id     = data.aws_ssm_parameter.keycloak_grafana_oidc_client_id.value
  keycloak_grafana_oidc_client_secret = data.aws_ssm_parameter.keycloak_grafana_oidc_client_secret.value

  ingress_group_name  = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "${module.env_info.envs[terraform.workspace].eks.cluster_name}-internal" : module.env_info.envs[terraform.workspace].eks.cluster_name
  ingress_group_order = lookup(module.env_info.envs.alb.ingress.group_orders, "grafana")
  ingress_scheme      = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "internal" : "internet-facing"

  aws_access_key_id     = data.aws_ssm_parameter.infra_platos_s3_access_key_id.value
  aws_secret_access_key = data.aws_ssm_parameter.infra_platos_s3_secret_access_key.value

  auth_url_path = module.env_info.envs[terraform.workspace].keycloak.auth_url_path

  depends_on = [
    module.keycloak
  ]
}

module "kafka_strimzi_operator" {
  source = "./modules/kafka_strimzi_operator"

  strimzi_cluster_operator = module.env_info.envs[terraform.workspace].kafka.strimzi_cluster_operator
}

module "kafka_cluster" {
  source = "./modules/kafka_cluster"

  depends_on = [
    module.kafka_strimzi_operator
  ]
}

module "gitlab_runner" {
  source = "./modules/gitlab-runner"

  count = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? 1 : 0
}

module "oauth2-proxy" {
  source = "./modules/oauth2-proxy"

  keycloak_hermes_oauth2proxy_oidc_client_id     = data.aws_ssm_parameter.keycloak_hermes_oauth2proxy_oidc_client_id.value
  keycloak_hermes_oauth2proxy_oidc_client_secret = data.aws_ssm_parameter.keycloak_hermes_oauth2proxy_oidc_client_secret.value

  keycloak_kafdrop_oauth2proxy_oidc_client_id     = data.aws_ssm_parameter.keycloak_kafdrop_oauth2proxy_oidc_client_id.value
  keycloak_kafdrop_oauth2proxy_oidc_client_secret = data.aws_ssm_parameter.keycloak_kafdrop_oauth2proxy_oidc_client_secret.value

  domain          = module.env_info.envs[terraform.workspace].domain
  keycloak_realm  = module.keycloak.keycloak_platos_realm
  certificate_arn = module.env_info.envs[terraform.workspace].certificate_arn

  ingress_group_name          = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "${module.env_info.envs[terraform.workspace].eks.cluster_name}-internal" : module.env_info.envs[terraform.workspace].eks.cluster_name
  hermes_ingress_group_order  = lookup(module.env_info.envs.alb.ingress.group_orders, "hermes")
  kafdrop_ingress_group_order = lookup(module.env_info.envs.alb.ingress.group_orders, "kafdrop")
  ingress_scheme              = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "internal" : "internet-facing"

  auth_url_path = module.env_info.envs[terraform.workspace].keycloak.auth_url_path

  depends_on = [
    module.keycloak
  ]
}

module "metabase" {
  source = "./modules/metabase"

  metabase_database_host     = data.aws_ssm_parameter.cosmos_database_host.value
  metabase_database_dbname   = "metabase"
  metabase_database_username = data.aws_ssm_parameter.metabase_database_username.value
  metabase_database_password = data.aws_ssm_parameter.metabase_database_password.value

  domain          = module.env_info.envs[terraform.workspace].domain
  certificate_arn = module.env_info.envs[terraform.workspace].certificate_arn

  ingress_group_name  = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "${module.env_info.envs[terraform.workspace].eks.cluster_name}-internal" : module.env_info.envs[terraform.workspace].eks.cluster_name
  ingress_group_order = lookup(module.env_info.envs.alb.ingress.group_orders, "metabase")
  ingress_scheme      = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "internal" : "internet-facing"
}

module "keda" {
  source = "./modules/keda"
}

module "kong" {
  source = "./modules/kong"

  count = contains(["dev", "stage"], module.env_info.envs[terraform.workspace].environment) ? 1 : 0

  certificate_arn = module.env_info.envs[terraform.workspace].certificate_arn
  domain          = module.env_info.envs[terraform.workspace].domain

  ingress_group_name  = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "${module.env_info.envs[terraform.workspace].eks.cluster_name}-internal" : module.env_info.envs[terraform.workspace].eks.cluster_name
  ingress_group_order = lookup(module.env_info.envs.alb.ingress.group_orders, "kong")
  ingress_scheme      = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "internal" : "internet-facing"

  replica_count = module.env_info.envs[terraform.workspace].kong.replica_count
  resources     = module.env_info.envs[terraform.workspace].kong.resources
}

module "sonarqube" {
  source = "./modules/sonarqube"

  count = contains(["stage", "production"], module.env_info.envs[terraform.workspace].environment) ? 1 : 0

  domain          = module.env_info.envs[terraform.workspace].domain
  certificate_arn = module.env_info.envs[terraform.workspace].certificate_arn

  ingress_group_name  = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "${module.env_info.envs[terraform.workspace].eks.cluster_name}-internal" : module.env_info.envs[terraform.workspace].eks.cluster_name
  ingress_group_order = lookup(module.env_info.envs.alb.ingress.group_orders, "sonarqube")
  ingress_scheme      = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "internal" : "internet-facing"

  database_hostname = data.aws_ssm_parameter.sonarqube_database_hostname.value
  database_name     = data.aws_ssm_parameter.sonarqube_database_name.value
  database_username = data.aws_ssm_parameter.sonarqube_database_username.value
  database_password = data.aws_ssm_parameter.sonarqube_database_password.value
}

module "efs_csi_driver" {
  source = "./modules/efs-csi-driver"

  iam_role_arn = data.terraform_remote_state.iam.outputs.aws_iam_roles_arn["eks_efs_csi_driver"]
}

module "cert_manager" {
  source = "./modules/cert-manager"
}

module "opentelemetry" {
  source = "./modules/opentelemetry"

  depends_on = [
    module.cert_manager
  ]
}

module "apps" {
  source = "./modules/apps"

  domain          = module.env_info.envs[terraform.workspace].domain
  certificate_arn = module.env_info.envs[terraform.workspace].certificate_arn
  environment     = module.env_info.envs[terraform.workspace].environment

  ingress_group_name   = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "${module.env_info.envs[terraform.workspace].eks.cluster_name}-internal" : module.env_info.envs[terraform.workspace].eks.cluster_name
  ingress_group_orders = module.env_info.envs.alb.ingress.group_orders
  ingress_scheme       = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? "internal" : "internet-facing"
}
