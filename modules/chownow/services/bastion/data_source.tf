# AWS network

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

# Subnet IDs

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkType"
    values = var.subnet_network_types
  }
}

# Security Groups

data "aws_security_group" "ingress_vpn_allow" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-vpn-sg-${local.env}"]
  }
}

# Route53 zones

data "aws_route53_zone" "private_zone" {
  name   = "${local.env}.aws.${var.domain}."
  vpc_id = data.aws_vpc.selected.id
}

data "aws_route53_zone" "svpn_public_zone" {
  name = "${local.custom_env}.svpn.${var.domain}."
}
