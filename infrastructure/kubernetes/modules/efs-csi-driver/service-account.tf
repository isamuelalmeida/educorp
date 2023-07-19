resource "kubernetes_service_account" "aws_efs_csi_driver_service_account" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "aws-efs-csi-driver"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = var.iam_role_arn
    }
    name      = "efs-csi-controller-sa"
    namespace = "kube-system"
  }
}
