data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}
data "aws_subnets" "public_base" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["public_base"]
  }
}

data "aws_subnets" "private_base" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}


data "aws_nat_gateway" "selected" {
  filter {
    name   = "tag:VPC"
    values = [local.vpc_name]
  }
}

###################
# ACM Certificate #
###################

data "aws_acm_certificate" "star_chownow" {
  domain      = "${var.wildcard_domain_prefix}${local.env}.svpn.${var.domain}"
  statuses    = ["ISSUED"]
  most_recent = true
}

#######
# ALB #
#######

data "aws_security_group" "ingress_vpn_allow" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-vpn-sg-${local.env}"]
  }
}

data "aws_route53_zone" "public" {
  name         = "${local.dns_zone}."
  private_zone = false
}

# Lookup for primary vpc info in non-prod environments
data "aws_vpc" "primary" {
  count = var.env == "ncp" ? 0 : 1

  filter {
    name   = "tag:Name"
    values = [local.env]
  }
}

# Lookup for private svpn zone in non-prod environments
data "aws_route53_zone" "primary_vpc_svpn_private" {
  count  = var.env == "ncp" ? 0 : 1
  name   = "${local.env}.svpn.${var.domain}."
  vpc_id = data.aws_vpc.primary[0].id
}

# chownowapi.com domain, public domain in case there are multiple
data "aws_route53_zone" "chownowapi" {
  name = local.route53_zone_mapping[local.env]
}

# look up which name is appropriate for this env, given a particular env slug
# required because the ncp and prod accounts don't match the rest of the account structure
# i prefer the map over the ternary because i'd like to throw a KeyError if we ever pass "prod" in
locals {
  route53_zone_mapping = {
    "ncp" = "chownowapi.com"
    "stg" = "stg.chownowapi.com"
    "qa"  = "qa.chownowapi.com"
    "uat" = "uat.chownowapi.com"
    "stg" = "stg.chownowapi.com"
    "dev" = "dev.chownowapi.com"
    # prod does not have a chownowapi.com domain
  }
}
