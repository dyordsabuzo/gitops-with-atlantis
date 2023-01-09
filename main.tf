resource "aws_ecr_repository" "ecr" {
  name = "ps-custom-atlantis"
}

resource "docker_registry_image" "image" {
  name = "${aws_ecr_repository.ecr.repository_url}:${data.external.command.result.sha}"

  build {
    context = "${path.cwd}/"
  }
}

resource "aws_iam_user" "user" {
  name = "ps-atlantis-user"
}

resource "aws_iam_user_group_membership" "group" {
  user   = aws_iam_user.user.name
  groups = [data.aws_iam_group.group.group_name]
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}

resource "aws_ssm_parameter" "access" {
  name  = "/atlantis/AWS_ACCESS_KEY_ID"
  type  = "SecureString"
  value = aws_iam_access_key.key.id
}

resource "aws_ssm_parameter" "secret" {
  name  = "/atlantis/AWS_SECRET_ACCESS_KEY"
  type  = "SecureString"
  value = aws_iam_access_key.key.secret
}

resource "aws_ssm_parameter" "environment" {
  for_each = toset(local.secret_variables)
  name     = "/atlantis/${each.key}"
  type     = "SecureString"
  value    = "UNSET"

  lifecycle {
    ignore_changes = [value]
  }
}
