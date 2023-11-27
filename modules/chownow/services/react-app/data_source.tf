data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_acm_certificate" "star_svpn" {
  domain      = "${var.wildcard_domain_prefix}${local.dns_zone}"
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_s3_bucket" "s3_access_logs" {
  # A bucket for s3 access logs presumed to exist
  bucket = "cn-s3-access-logs-${local.env}"
}

data "aws_s3_bucket" "cloudfront_access_logs" {
  # this is the convention used
  bucket = "cn-cloudfront-access-logs-${local.env}"
}

data "aws_route53_zone" "svpn" {
  name         = local.dns_zone
  private_zone = false
}

data "aws_iam_role" "lambda_s3_cleanup" {
  name = "lambda-s3-cleanup-${local.env}"
}
