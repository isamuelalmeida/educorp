output "aws_iam_pritunl_ec2_instance_profile_id" {
  value = aws_iam_instance_profile.ec2_profile.id
}

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