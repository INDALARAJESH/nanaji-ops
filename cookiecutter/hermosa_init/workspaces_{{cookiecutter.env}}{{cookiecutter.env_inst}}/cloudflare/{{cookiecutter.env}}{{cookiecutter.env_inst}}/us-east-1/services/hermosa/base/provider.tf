terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-{{cookiecutter.env}}"
    key    = "cloudflare/{{cookiecutter.env}}{{cookiecutter.env_inst}}/us-east-1/services/hermosa/base/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.32.0"
    }
  }
  required_version = ">= 0.14.7"
}
