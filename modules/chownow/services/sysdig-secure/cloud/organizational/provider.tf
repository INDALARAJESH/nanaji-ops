terraform {
  required_providers {
    sysdig = {
      source = "sysdiglabs/sysdig"
    }
  }
}

provider "aws" {
  alias  = "mgmt"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_mgmt_account_id}:role/${var.aws_assume_role_name}"
  }

  default_tags {
    tags = {
      Env           = "${var.env}${var.env_inst}"
      Service       = "sysdig-secure"
      ServiceFamily = "Security"
      TFWorkspace   = "terraform/environments/mgmt/us-east-1/services/sysdig-secure/cloud"
    }
  }
}
