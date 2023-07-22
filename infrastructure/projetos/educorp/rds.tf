module "educorp_rds" {
  for_each = local.customers.envs[terraform.workspace]

  source  = "terraform-aws-modules/rds/aws"
  version = "5.4.2"

  identifier = each.value.rds.identifier

  engine         = "mysql"
  engine_version = "8.0.28"
  instance_class = each.value.rds.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 40
  storage_type          = "gp3"

  db_name  = "wp_educorp"
  username = aws_ssm_parameter.educorp_database_username[each.key].value
  password = aws_ssm_parameter.educorp_database_password[each.key].value

  create_random_password = false

  # Obs: O snapshot final fica associado ao option group e isso impede que o mesmo seja removido ao rodar um terraform destroy
  # create_db_option_group = false

  skip_final_snapshot = each.value.rds.skip_final_snapshot

  publicly_accessible = false

  apply_immediately = true

  vpc_security_group_ids = [
    data.terraform_remote_state.baseline.outputs.vpc_default_security_group_id,
    data.terraform_remote_state.eks.outputs.eks_cluster_primary_security_group_id
  ]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # DB subnet group
  db_subnet_group_name = data.terraform_remote_state.baseline.outputs.vpc_database_subnet_group_name
  subnet_ids           = data.terraform_remote_state.baseline.outputs.vpc_database_subnets

  family = "mysql8.0"

  major_engine_version = "8.0"

  deletion_protection = false

  backup_retention_period = terraform.workspace == "production" ? 7 : 0

  performance_insights_enabled = each.value.rds.performance_insights_enabled

  enabled_cloudwatch_logs_exports = terraform.workspace == "production" ? ["audit", "error", "general", "slowquery"] : []

  tags = {
    Name = each.value.rds.identifier
  }
}