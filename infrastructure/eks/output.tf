output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_load_balancer_controller_role_arn" {
  value = module.iam_assumable_role_alb.iam_role_arn
}

output "eks_cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}