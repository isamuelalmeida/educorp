resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "eks_keypair" {
  key_name   = "eks_keypair_${terraform.workspace}"
  public_key = tls_private_key.main.public_key_openssh
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.2"

  cluster_name    = module.env_info.envs[terraform.workspace].eks.cluster_name
  cluster_version = module.env_info.envs[terraform.workspace].eks.cluster_version

  vpc_id     = data.terraform_remote_state.baseline.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.baseline.outputs.aws_private_subnets

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.8.7-eksbuild.3"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.24.7-eksbuild.2"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.11.4-eksbuild.1"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.20.0-eksbuild.1"
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_accounts = [module.env_info.envs[terraform.workspace].account_id]
  aws_auth_users    = module.env_info.envs[terraform.workspace].eks.aws_auth_users
  aws_auth_roles    = module.env_info.envs[terraform.workspace].eks.aws_auth_roles

  enable_irsa = true

  node_security_group_additional_rules = {
    ingress_nodes_karpenter_port = {
      description                   = "Cluster API to Node group for Karpenter webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  node_security_group_tags = {
    "kubernetes.io/cluster/${module.env_info.envs[terraform.workspace].eks.cluster_name}" = null
  }

  tags = {
    "karpenter.sh/discovery" = module.env_info.envs[terraform.workspace].eks.cluster_name
  }
}

module "eks_managed_node_group_initial" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "18.31.2"

  name            = "${var.node_group_name_by_env[terraform.workspace]}-initial"
  cluster_name    = module.env_info.envs[terraform.workspace].eks.cluster_name
  cluster_version = module.env_info.envs[terraform.workspace].eks.cluster_version

  vpc_id                            = data.terraform_remote_state.baseline.outputs.vpc_id
  subnet_ids                        = data.terraform_remote_state.baseline.outputs.aws_private_subnets
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids = [
    module.eks.cluster_security_group_id,
  ]

  min_size = module.env_info.envs[terraform.workspace].eks.node_group_initial.min_size
  max_size = module.env_info.envs[terraform.workspace].eks.node_group_initial.max_size
  # Obs: Aparentemente o módulo do EKS Managed Node Group ignora a configuração de "desired size", sendo
  # necessário realizar essa alteração pelo console da AWS
  # Link: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/835#issuecomment-665438394
  desired_size = module.env_info.envs[terraform.workspace].eks.node_group_initial.desired_size

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = module.env_info.envs[terraform.workspace].eks.node_group_initial.disk_size
        volume_type           = "gp3"
        encrypted             = false
        delete_on_termination = true
      }
    }
  }

  instance_types = module.env_info.envs[terraform.workspace].eks.node_group_initial.instance_types
  capacity_type  = module.env_info.envs[terraform.workspace].eks.node_group_initial.capacity_type
  ami_type       = module.env_info.envs[terraform.workspace].eks.node_group_initial.ami_type

  iam_role_additional_policies = [
    data.terraform_remote_state.iam.outputs.aws_iam_policies_arn["eks_efs_csi_driver"],
    data.terraform_remote_state.iam.outputs.aws_iam_policies_arn["eks_ebs_volume"]
  ]

  labels = module.env_info.envs[terraform.workspace].eks.node_group_initial.labels
}