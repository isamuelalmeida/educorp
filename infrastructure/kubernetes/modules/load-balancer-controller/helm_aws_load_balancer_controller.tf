resource "helm_release" "aws_load_balancer_controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = "1.5.5"
  namespace        = "kube-system"
  create_namespace = true

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.role_arn
  }

  set {
    name  = "region"
    value = var.region
  }


  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  values = [<<-EOT
    nodeSelector:
      nodeTypeClass: microservices

  EOT
  ]

}
