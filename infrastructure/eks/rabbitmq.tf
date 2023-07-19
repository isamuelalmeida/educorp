data "aws_ssm_parameter" "rabbitmq_default_user" {
  name = "/rabbitmq_default_user"
}

data "aws_ssm_parameter" "rabbitmq_default_password" {
  name = "/rabbitmq_default_password"
}

resource "aws_mq_broker" "rabbitmq_broker" {
  broker_name = "rabbitmq-eks-${terraform.workspace}"

  engine_type                = "RabbitMQ"
  engine_version             = module.env_info.envs[terraform.workspace].rabbitmq.engine_version
  host_instance_type         = module.env_info.envs[terraform.workspace].rabbitmq.host_instance_type
  subnet_ids                 = [data.terraform_remote_state.baseline.outputs.aws_public_subnets[0]]
  apply_immediately          = true
  deployment_mode            = module.env_info.envs[terraform.workspace].rabbitmq.deployment_mode
  auto_minor_version_upgrade = true
  publicly_accessible        = true

  user {
    username = data.aws_ssm_parameter.rabbitmq_default_user.value
    password = data.aws_ssm_parameter.rabbitmq_default_password.value
  }
}
