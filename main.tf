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

module "pablosspot-lb" {
  source  = "app.terraform.io/pablosspot/pablosspot-lb/aws"
  version = "0.0.4"
  # insert required variables here

  base_domain = local.base_domain
  system_name = "generic"
  endpoints   = ["atlantis"]

}

module "pablosspot-ecs" {
  source  = "app.terraform.io/pablosspot/pablosspot-ecs/aws"
  version = "0.12.9"
  # insert required variables here
  cluster_name = "atlantis"
  service_name = "atlantis"
  task_family  = "atlantis"

  launch_type = {
    type   = "FARGATE"
    cpu    = 256
    memory = 512
  }

  container_definitions = jsonencode([{
    name           = "atlantis"
    image          = docker_registry_image.image.name
    container_port = 4141
    environment    = local.env_variables
    secrets        = local.secrets
    command        = ["server"]
  }])

  endpoint_details = {
    lb_listener_arn = module.pablosspot-lb.lb_listener_arn
    domain_url      = local.atlantis_url
  }
}
