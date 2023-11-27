data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "main" {
  domain      = local.certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "svpn" {
  name         = "${local.certificate_domain}."
  private_zone = false
}

data "aws_lambda_alias" "lambda_sec_headers" {
  function_name = "cloudfront-sec-headers-${local.env}"
  name          = "latest"
}

data "aws_lambda_function" "lambda_sec_headers" {
  function_name = "cloudfront-sec-headers-${local.env}"
  qualifier     = data.aws_lambda_alias.lambda_sec_headers.function_version
}
