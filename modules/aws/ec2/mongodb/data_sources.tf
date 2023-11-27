data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = [data.aws_caller_identity.current.account_id]

  filter {
    name   = "name"
    values = ["cn-${var.service}-db-*"]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}


data "aws_route53_zone" "private" {
  vpc_id       = data.aws_vpc.selected.id
  name         = "${var.dns_zone}."
  private_zone = true
}

data "aws_key_pair" "ec2" {
  key_name           = "${var.service}-${local.env}"
  include_public_key = true

  filter {
    name   = "tag:Service"
    values = [var.service]
  }
}
