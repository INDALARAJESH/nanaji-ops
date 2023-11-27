data "aws_acm_certificate" "public" {
  domain      = local.certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_security_group" "ingress_cloudflare" {
  filter {
    name   = "tag:Name"
    values = ["ingress-cloudflare-${local.env}"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_security_group" "vpn_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-vpn-sg-${local.env}"]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_route53_zone" "public" {
  name         = "${local.env}.${var.domain_public}"
  private_zone = false
}

data "aws_lb" "public" {
  name = "${local.service}-pub-${local.env}"
}

data "aws_lb_listener" "public" {
  load_balancer_arn = data.aws_lb.public.arn
  port              = var.listener_port
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
# var.domain_public used over var.domain_private because
# of naming inconsistencies present in the primary VPC's
# route53 Hosted Zones (no private svpn zone in nc VPCs)
data "aws_route53_zone" "primary_vpc_svpn_private" {
  count  = local.env == "ncp" ? 0 : 1
  name   = "${local.env}.${var.domain_public}."
  vpc_id = data.aws_vpc.primary[count.index].id
}
