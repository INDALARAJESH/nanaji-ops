data "aws_caller_identity" "current" {}

data "aws_api_gateway_rest_api" "api" {
  name = var.api_gateway_name
}
