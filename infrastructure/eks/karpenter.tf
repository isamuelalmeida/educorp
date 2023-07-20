# 1
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "18.31.0"

  cluster_name = module.env_info.envs[terraform.workspace].eks.cluster_name

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  create_iam_role = false
  iam_role_arn    = module.eks_managed_node_group_initial.iam_role_arn
}

# 2
data "aws_ecrpublic_authorization_token" "token" {}

resource "helm_release" "karpenter" {

  namespace        = "karpenter"
  create_namespace = true

  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "v0.20.0"

  set {
    name  = "replicas"
    value = module.env_info.envs[terraform.workspace].eks.karpenter.replicas
  }

  set {
    name  = "nodeSelector.nodeTypeClass"
    value = "initial"
  }

  set {
    name  = "settings.aws.clusterName"
    value = module.env_info.envs[terraform.workspace].eks.cluster_name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.irsa_arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = module.karpenter.queue_name
  }

  set {
    name  = "serviceMonitor.enabled"
    value = "false"
  }
  set {
    name  = "serviceMonitor.additionalLabels.release"
    value = "prometheus"
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = module.env_info.envs[terraform.workspace].eks.karpenter.resources.requests.cpu
  }
  set {
    name  = "controller.resources.requests.memory"
    value = module.env_info.envs[terraform.workspace].eks.karpenter.resources.requests.memory
  }
  set {
    name  = "controller.resources.limits.cpu"
    value = module.env_info.envs[terraform.workspace].eks.karpenter.resources.limits.cpu
  }
  set {
    name  = "controller.resources.limits.memory"
    value = module.env_info.envs[terraform.workspace].eks.karpenter.resources.limits.memory
  }

  set {
    name  = "logLevel"
    value = "info"
  }
}