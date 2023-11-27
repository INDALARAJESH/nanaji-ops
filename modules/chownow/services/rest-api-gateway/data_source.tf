data "aws_acm_certificate" "cert" {
  domain      = var.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "api" {
  name = var.domain
}
