output "aws_iam_roles_arn" {
  value = {
    for k, v in local.accounts : k => module.iam_user[k].iam_user_arn
  }
}

output "aws_iam_policies_arn" {
  value = {
    for k, v in local.accounts : k => aws_iam_policy.iam_policy[k].arn
  }
}