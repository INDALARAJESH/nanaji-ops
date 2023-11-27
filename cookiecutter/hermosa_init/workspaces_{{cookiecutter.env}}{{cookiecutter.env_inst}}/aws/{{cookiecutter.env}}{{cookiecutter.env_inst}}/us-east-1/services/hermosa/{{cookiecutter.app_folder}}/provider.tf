terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-{{cookiecutter.env}}"
    key    = "{{cookiecutter.env}}{{cookiecutter.env_inst}}/us-east-1/services/hermosa/{{cookiecutter.app_folder}}/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"
    }
  }
  required_version = ">= 0.14.7"
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
  region = "us-east-1"

  default_tags {
    tags = {
      TFWorkspace   = "ops/terraform/environments/{{cookiecutter.env}}{{cookiecutter.env_inst}}/us-east-1/services/hermosa/{{cookiecutter.app_folder}}"
      Service       = "hermosa"
      ServiceFamily = "Hermosa"
      Env           = "${var.env}${var.env_inst}"
    }
  }
}
