data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# ACM Certificate

data "aws_acm_certificate" "star_chownow" {
  domain   = "${var.wildcard_domain_prefix}${local.env}.svpn.${var.domain}"
  statuses = ["ISSUED"]
}

# VPC

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_private_subnet_tag_key]
  }
}

# ALB

data "aws_security_group" "ingress_vpn_allow" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-vpn-sg-${local.env}"]
  }
}

data "aws_route53_zone" "public" {
  name         = "${local.dns_zone}."
  private_zone = false
}
