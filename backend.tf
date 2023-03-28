terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "pablosspot"

    workspaces {
      prefix = "ps-atlantis-ecs-"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.15.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.0"
    }

    okta = {
      source  = "okta/okta"
      version = "~> 3.37"
    }
  }
}
