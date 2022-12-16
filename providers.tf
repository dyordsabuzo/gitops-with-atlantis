provider "aws" {
  region = var.region

  default_tags {
    tags = {
      created_by = "terraform"
      workspace  = terraform.workspace
    }
  }
}

provider "docker" {
  registry_auth {
    address  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
