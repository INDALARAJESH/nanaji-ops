data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_canonical_user_id" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_acm_certificate" "svpn" {
  domain      = local.svpn_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_security_group" "ingress_cloudflare" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["allow-cloudflare-ips-${local.vpc_name}"]
  }
}

data "aws_security_group" "internal" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["internal-${local.vpc_name}"]
  }
}

data "aws_security_group" "ops" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["ops-alb allows"]
  }
}

// data "aws_route53_zone" "public" {
//   name         = "${local.svpn_domain}."
//   private_zone = false
// }

data "aws_acm_certificate" "star_svpn" {
  domain      = local.svpn_domain
  statuses    = ["ISSUED"]
  most_recent = true
}
