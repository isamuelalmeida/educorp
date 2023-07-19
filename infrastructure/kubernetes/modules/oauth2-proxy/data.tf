data "aws_ssm_parameter" "oauth2proxy_cookie_secret" {
  name = "/${terraform.workspace}/oauth2proxy_cookie_secret"
}