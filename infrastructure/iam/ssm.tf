resource "aws_ssm_parameter" "infra_platos_s3_access_key_id" {
  name  = "/infra_platos_s3_access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.infra_platos_s3_n2.id
}

resource "aws_ssm_parameter" "infra_platos_s3_secret_access_key" {
  name  = "/infra_platos_s3_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.infra_platos_s3_n2.secret
}

resource "aws_ssm_parameter" "service_crm_access_key_id" {
  name  = "/service_crm_access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.service_crm_access_key.id
}

resource "aws_ssm_parameter" "service_crm_secret_access_key" {
  name  = "/service_crm_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.service_crm_access_key.secret
}

resource "aws_ssm_parameter" "educorp_access_key_id" {
  name  = "/educorp_access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.educorp_access_key.id
}

resource "aws_ssm_parameter" "educorp_secret_access_key" {
  name  = "/educorp_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.educorp_access_key.secret
}

resource "aws_ssm_parameter" "service_auth_access_key_id" {
  name  = "/service_auth_access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.service_auth_access_key.id
}

resource "aws_ssm_parameter" "service_auth_secret_access_key" {
  name  = "/service_auth_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.service_auth_access_key.secret
}