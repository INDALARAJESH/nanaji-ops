data "aws_acm_certificate" "public" {
  domain      = "${local.env}.svpn.${var.domain}"
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_security_group" "ingress_vpn_allow" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-vpn-sg-${local.env}"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_route53_zone" "public" {
  name         = local.dns_zone
  private_zone = false
}

data "aws_caller_identity" "current" {}
