data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "api" {
  name = local.domain_name
}

data "aws_acm_certificate" "cert" {
  domain      = local.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_kms_key" "pos_square" {
  key_id = local.key_id
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [format("%s-%s", var.vpc_name_prefix, local.env)]
  }
}
