terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-{{cookiecutter.env}}"
    key    = "{{cookiecutter.env}}{{cookiecutter.env_inst}}/us-east-1/services/hermosa/cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }

  region = "us-east-1"

  default_tags {
    tags = {
      TFWorkspace   = "ops/terraform/environments/{{cookiecutter.env}}{{cookiecutter.env_inst}}/us-east-1/services/hermosa/cluster"
      Service       = "hermosa"
      ServiceFamily = "Hermosa"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 0.14.7"
}
