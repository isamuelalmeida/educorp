module "monitoring" {
  source = "./modules/monitoring"

  environment = module.env_info.envs[terraform.workspace].environment

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

module "gitlab_runner" {
  source = "./modules/gitlab-runner"

  count = contains(["dev"], module.env_info.envs[terraform.workspace].environment) ? 1 : 0
}

module "efs_csi_driver" {
  source = "./modules/efs-csi-driver"

  iam_role_arn = data.terraform_remote_state.iam.outputs.aws_iam_roles_arn["eks_efs_csi_driver"]
}