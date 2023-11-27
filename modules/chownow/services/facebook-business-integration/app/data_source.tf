data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "api" {
  name = local.domain_name
}

data "aws_kms_key" "fbe" {
  key_id = local.key_id
}

data "aws_api_gateway_rest_api" "api" {
  name = var.api_gateway_name
}
