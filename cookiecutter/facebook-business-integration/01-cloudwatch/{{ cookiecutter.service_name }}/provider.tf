terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-{{ cookiecutter.environment }}"
    key    = "{{ cookiecutter.environment }}/us-east-1/api-gateway/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
  default_tags {
    tags = {
      TFWorkspace = "terraform/environments/{{ cookiecutter.environment }}/us-east-1/api-gateway"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.2"
}