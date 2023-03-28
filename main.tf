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
  version = "0.12.11"
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

  authenticate_oidc_details = {
    client_id     = okta_app_oauth.oidc.client_id
    client_secret = okta_app_oauth.oidc.client_secret
    oidc_endpoint = data.aws_ssm_parameter.okta.value
  }

  lb_authentication_exclusion = {
    header_names   = ["X-Hub-Signatures-256"]
    path_pattern   = ["/events"]
    request_method = ["POST"]
  }
}

resource "okta_app_oauth" "oidc" {
  label          = "Atlantis OIDC"
  type           = "web"
  omit_secret    = false
  grant_types    = ["authorization_code"]
  response_types = ["code"]
  redirect_uris  = ["https://atlantis.pablosspot.ml/oauth2/idpresponse"]
}

resource "okta_app_group_assignment" "assignment" {
  app_id   = okta_app_oauth.oidc.id
  group_id = data.okta_group.group.id
}
