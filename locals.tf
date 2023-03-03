locals {
  base_domain  = "pablosspot.ml"
  atlantis_url = "atlantis.${local.base_domain}"
  repos_json   = jsonencode(yamldecode(file("${path.module}/config/repos.yaml")))

  env_variables = {
    ATLANTIS_ATLANTIS_URL                = "https://${local.atlantis_url}"
    ATLANTIS_REPO_ALLOWLIST              = var.atlantis_repo_allowlist
    ATLANTIS_REPO_CONFIG_JSON            = local.repos_json
    ATLANTIS_WRITE_GIT_CREDS             = "true"
    ATLANTIS_DISABLE_APPLY_ALL           = "true"
    ATLANTIS_SILENCE_NO_PROJECTS         = "true"
    ATLANTIS_PORT                        = "4141"
    ATLANTIS_ENABLE_DIFF_MARKDOWN_FORMAT = "true"
  }

  secret_variables = [
    "ATLANTIS_GH_APP_ID",
    "ATLANTIS_GH_APP_KEY",
    "ATLANTIS_GH_WEBHOOK_SECRET",
    "TERRAFORM_CLOUD_TOKEN"
  ]

  secrets = merge({
    AWS_ACCESS_KEY_ID     = aws_ssm_parameter.access.arn
    AWS_SECRET_ACCESS_KEY = aws_ssm_parameter.secret.arn
    },
    {
      for item in local.secret_variables :
      item => data.aws_ssm_parameter.environment[item].arn
  })
}
