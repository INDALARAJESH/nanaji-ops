data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "cert" {
  domain      = local.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "api" {
  name = local.domain_name
}
