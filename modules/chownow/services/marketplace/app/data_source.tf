data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# ACM Certificate

data "aws_acm_certificate" "star_chownow" {
  domain      = local.aws_acm_certificate
  statuses    = ["ISSUED"]
  most_recent = true

}

# VPC

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

# ALB

data "aws_security_group" "ingress_vpn_allow" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = [local.security_group_name]
  }
}

data "aws_route53_zone" "private" {
  name         = "${local.dns_zone}."
  private_zone = var.private_zone_boolean
}

data "aws_security_group" "ingress_cloudflare" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["allow-cloudflare-ips-${local.vpc_name}"]
  }
}

# ORDER DIRECT CLOUDFRONT

data "aws_cloudfront_distribution" "order_direct_cloudfront" {
  count = var.env == "prod" ? 0 : 1
  id    = var.order_direct_distribution_id
}

# SYSDIG 

data "aws_lb" "sysdig_orchestrator" {
  count = var.enable_sysdig ? 1 : 0
  tags = {
    "Name" = "sysdig-orchestrator-${local.vpc_name}"
  }
}
