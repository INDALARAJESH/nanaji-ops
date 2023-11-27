// Networking

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnet_ids" "base" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = ["${var.subnet_tag}_base"]
  }
}

data "aws_subnet_ids" "subnet" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkType"
    values = [var.subnet_tag]
  }
}

data "aws_subnet" "subnet" {
  count = length(data.aws_subnet_ids.subnet.ids)
  id    = tolist(data.aws_subnet_ids.subnet.ids)[count.index]
}

data "aws_route53_zone" "aws" {
  vpc_id       = data.aws_vpc.selected.id
  name         = "${local.env}.aws.${var.domain}."
  private_zone = var.is_private
}

// RDS

data "aws_secretsmanager_secret" "pgmaster_password" {
  count = local.create_pgmaster_password == 0 ? 1 : 0
  name  = var.pgmaster_secret_name
}

data "aws_secretsmanager_secret_version" "pgmaster_password" {
  count = local.create_pgmaster_password == 0 ? 1 : 0

  secret_id     = data.aws_secretsmanager_secret.pgmaster_password[0].id
  version_stage = "AWSCURRENT"
}

