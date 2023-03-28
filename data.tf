data "aws_caller_identity" "current" {

}

data "aws_ecr_authorization_token" "token" {

}

data "external" "command" {
  program = ["sh", "${path.module}/scripts/get-short-sha.sh"]
}

data "aws_iam_group" "group" {
  group_name = "DeploymentGroup"
}


data "aws_ssm_parameter" "environment" {
  for_each = toset(local.secret_variables)
  name     = "/atlantis/${each.key}"
}

data "okta_group" "group" {
  name = "Developer"
}

data "aws_ssm_parameter" "okta" {
  name = "/tool/okta/ORG_URL"
}

data "aws_ssm_parameter" "org_name" {
  name = "/tool/okta/ORG_NAME"
}

data "aws_ssm_parameter" "base_url" {
  name = "/tool/okta/BASE_URL"
}

data "aws_ssm_parameter" "token" {
  name            = "/tool/okta/TOKEN"
  with_decryption = true
}
