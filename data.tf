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
