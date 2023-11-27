data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# ACM Certificate

data "aws_acm_certificate" "star_chownow" {
  domain      = "${var.wildcard_domain_prefix}${local.env}.svpn.${var.domain}"
  statuses    = ["ISSUED"]
  most_recent = true

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


# GMAIL SMTP KEYS

data "aws_secretsmanager_secret" "gmail_username" {
  name = "${local.env}/${var.service}/gmail_username"
}

data "aws_secretsmanager_secret_version" "gmail_username" {
  secret_id     = data.aws_secretsmanager_secret.gmail_username.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "gmail_password" {
  name = "${local.env}/${var.service}/gmail_password"
}

data "aws_secretsmanager_secret_version" "gmail_password" {
  secret_id     = data.aws_secretsmanager_secret.gmail_password.id
  version_stage = "AWSCURRENT"
}
