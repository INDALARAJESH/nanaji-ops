data "aws_route53_zone" "delegate_chownowapi" {
  provider = aws.delegate
  name     = "${local.env}.${var.domain}"
}

data "aws_route53_zone" "chownowapi" {
  name = var.domain
}
