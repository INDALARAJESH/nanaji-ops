# Network
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_security_group" "internal_allow" {
  count = local.enable_internal_allow

  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["internal-${local.env}"]
  }

}

# Secrets Manager Lookup
data "aws_secretsmanager_secret" "tenable_api_token" {
  name = "${var.env}/tenable/api"
}

data "aws_secretsmanager_secret_version" "tenable_api_token" {
  secret_id     = data.aws_secretsmanager_secret.tenable_api_token.id
  version_stage = "AWSCURRENT"
}

# AMI lookup

data "aws_ami" "nessus" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Tenable Core*Nessus*"]
  }
}
