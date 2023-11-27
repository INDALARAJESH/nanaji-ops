terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-{{ cookiecutter.environment }}"
    key    = "{{ cookiecutter.environment }}{{ cookiecutter.environment_instance }}/us-east-1/services/{{ cookiecutter.service_path }}/{{ cookiecutter.service_name }}/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"
    }
  }
  required_version = ">= 0.14.6"

}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }

  region = "us-east-1"

  default_tags {
    tags = {
      TFWorkspace   = "ops/terraform/{{ cookiecutter.environment }}{{ cookiecutter.environment_instance }}/us-east-1/services/{{ cookiecutter.service_path }}/{{ cookiecutter.service_name }}"
      TFService     = "{{ cookiecutter.service_name }}"
      ServiceFamily = "Hermosa"
      Env           = "${var.env}${var.env_inst}"
    }
  }
}
