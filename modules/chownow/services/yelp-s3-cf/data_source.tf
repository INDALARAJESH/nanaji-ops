data "aws_acm_certificate" "cert" {
  domain      = local.dns_zone
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_s3_bucket" "app" {
  bucket = "cn-app-order-direct-${local.env}"
}

data "aws_s3_bucket" "cloudfront_access_logs" {
  # this is the convention used
  bucket = "cn-cloudfront-access-logs-${local.env}"
}

data "aws_route53_zone" "svpn" {
  name         = local.dns_zone
  private_zone = false
}
