data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "orchestrator_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private_vpc_subnets" {
  filter {
    name   = "tag:VPC"
    values = [var.vpc_name]
  }

  tags = {
    NetworkType = "private"
  }
}

data "aws_route53_zone" "private_vpc_zone" {
  name         = "${local.env}.aws.chownow.com"
  private_zone = true
  vpc_id       = local.vpc_id
}

data "aws_secretsmanager_secret" "sysdig_access_key" {
  name = "${local.env}/sysdig-secure/sysdig_access_key"
}

# Might not need, will confirm after testing
data "aws_secretsmanager_secret_version" "sysdig_access_key" {
  secret_id     = data.aws_secretsmanager_secret.sysdig_access_key.id
  version_stage = "AWSCURRENT"
}
