data "aws_ssm_parameter" "gitlab_runner_registration_token" {
  name = "/gitlab_runner_registration_token"
}

data "aws_ssm_parameter" "gitlab_runner_registration_token_platos" {
  name = "/gitlab_runner_registration_token_platos"
}

data "aws_ssm_parameter" "gitlab_runner_registration_token_portalpos" {
  name = "/gitlab_runner_registration_token_portalpos"
}