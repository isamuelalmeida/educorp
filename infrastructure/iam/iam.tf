module "iam_user" {
  for_each                      = local.accounts
  source                        = "terraform-aws-modules/iam/aws//modules/iam-user"
  name                          = each.key
  create_iam_user_login_profile = false
  create_iam_access_key         = true
}

resource "aws_iam_user_policy_attachment" "policy_attachment" {
  for_each   = local.accounts
  user       = module.iam_user[each.key].iam_user_name
  policy_arn = aws_iam_policy.iam_policy[each.key].arn
}

resource "aws_iam_policy" "iam_policy" {
  for_each = local.accounts
  name     = "iam-policy-${each.key}"
  path     = "/"
  policy   = <<EOF
${data.template_file.policy[each.key].rendered}
EOF
}

data "template_file" "policy" {
  for_each = local.accounts
  template = file("${path.module}/policies/${each.value}")
}

resource "aws_ssm_parameter" "access_key_id" {
  for_each = local.accounts
  name     = "${each.key}_access_key_id"
  type     = "SecureString"
  value    = module.iam_user[each.key].iam_access_key_id
}

resource "aws_ssm_parameter" "access_key_secret" {
  for_each = local.accounts
  name     = "${each.key}_access_key_secret"
  type     = "SecureString"
  value    = module.iam_user[each.key].iam_access_key_secret
}