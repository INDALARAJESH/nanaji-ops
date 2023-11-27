data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_api_gateway_rest_api" "api" {
  name = local.app_name
}

data "aws_s3_bucket" "onboarding_files_bucket" {
  bucket = local.onboarding_files_s3_bucket_name
}

data "aws_cloudwatch_log_group" "gateway" {
  name = "/aws/api-gateway/${local.app_name}-log-group-${local.env}"
}

data "aws_api_gateway_domain_name" "this_public" {
  domain_name = local.env == "ncp" ? "onboarding.chownowapi.com" : "onboarding.${local.env}.chownowapi.com"
}

data "aws_cloudwatch_event_source" "sfdc_appflow_event_source" {
  name_prefix = "${var.sfdc_integration_partner_prefix}/${data.aws_caller_identity.current.id}/${local.sfdc_event_bus_name}"
  depends_on  = [aws_appflow_flow.salesforce_flow]
}
