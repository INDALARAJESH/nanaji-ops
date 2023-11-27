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

data "aws_security_group" "ingress_cloudflare" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["allow-cloudflare-ips-${local.vpc_name}"]
  }
}

# Mongo DB EC2 user data
data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
  vars = {
    mongo_key     = random_string.mongo_key.result
    appsmithrw    = module.secret_name_appsmithrw.secret_arn
    appsmithadmin = module.secret_name_appsmithadmin.secret_arn
  }
}

data "aws_secretsmanager_secret_version" "secret-version" {
  secret_id = module.secret_name_appsmithrw.secret_arn
}
