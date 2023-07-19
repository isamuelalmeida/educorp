resource "aws_kms_key" "efs" {
  for_each    = local.customers.envs[terraform.workspace]
  description = "educorp-${each.key}-${terraform.workspace}"
}

resource "aws_kms_alias" "eks" {
  for_each      = local.customers.envs[terraform.workspace]
  name          = "alias/${aws_kms_key.efs[each.key].description}"
  target_key_id = aws_kms_key.efs[each.key].key_id
}

locals {
  #TODO: Refatorar locals "aws_azs" e "aws_private_subnets" para receber esses valores via inputs do módulo. No workspace de production
  # esses valores deverão vir de outra forma e não via "terraform_remote_state"
  aws_azs             = data.terraform_remote_state.baseline.outputs.aws_azs
  aws_private_subnets = data.terraform_remote_state.baseline.outputs.aws_private_subnets
  mount_targets       = { for key, value in zipmap(local.aws_azs, local.aws_private_subnets) : key => { subnet_id = value } }
}

module "efs" {
  for_each = local.customers.envs[terraform.workspace]
  source   = "terraform-aws-modules/efs/aws"
  version  = "1.1.1"

  # File system
  name        = "educorp-${each.key}-${terraform.workspace}"
  encrypted   = true
  kms_key_arn = aws_kms_key.efs[each.key].arn

  performance_mode                = each.value.efs.performance_mode
  throughput_mode                 = each.value.efs.throughput_mode
  provisioned_throughput_in_mibps = each.value.efs.provisioned_throughput_in_mibps

  # Docs: https://docs.aws.amazon.com/efs/latest/ug/API_LifecyclePolicy.html
  lifecycle_policy = {
    # IA = Infrequent Access
    transition_to_ia = "AFTER_30_DAYS"
  }

  # Mount targets / security group
  mount_targets              = local.mount_targets
  security_group_description = "EFS security group"
  security_group_vpc_id      = data.terraform_remote_state.baseline.outputs.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provided for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = data.terraform_remote_state.baseline.outputs.aws_private_subnets_cidr_blocks
    }
  }

  # Backup policy
  enable_backup_policy = true

  attach_policy = false
}

