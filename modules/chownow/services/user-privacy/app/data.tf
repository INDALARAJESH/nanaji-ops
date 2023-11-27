data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_api_gateway_rest_api" "api" {
  name = local.app_name
}

data "aws_api_gateway_domain_name" "this_public" {
  domain_name = local.env == "ncp" ? "user-privacy.chownowapi.com" : "user-privacy.${local.env}.chownowapi.com"
}

data "aws_cloudwatch_log_group" "gateway" {
  name = "/aws/api-gateway/${local.app_name}-log-group-${local.env}"
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [format("%s-%s", var.vpc_name_prefix, local.env)]
  }
}

data "aws_subnet_ids" "private_base" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_private_subnet_tag_key]
  }
}
