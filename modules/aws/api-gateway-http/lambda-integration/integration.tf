resource "aws_apigatewayv2_integration" "lambda-integration" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"

  integration_method     = "POST"
  integration_uri        = var.lambda_invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = var.payload_format_version
}

resource "aws_apigatewayv2_route" "lambda-route" {
  count     = var.enable_default_route
  api_id    = var.api_id
  route_key = "ANY ${var.path_prefix}/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-integration.id}"
}
