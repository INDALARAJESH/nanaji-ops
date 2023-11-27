# Module for public-facing API Gateway deployment

resource "aws_api_gateway_deployment" "webhook_api" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.webhook_api.body,
      data.aws_iam_policy_document.webhook_api,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.webhook_api.id
  rest_api_id   = aws_api_gateway_rest_api.webhook_api.id
  stage_name    = "api"


  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.gateway.arn
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "caller" : "$context.identity.caller", "user" : "$context.identity.user", "requestTime" : "$context.requestTime", "httpMethod" : "$context.httpMethod", "resourcePath" : "$context.resourcePath", "status" : "$context.status", "protocol" : "$context.protocol", "responseLength" : "$context.responseLength", "userAgent" : "$context.identity.userAgent", "integrationError" : "$context.integration.error", "sourceIp" : "$context.identity.sourceIp", "routeKey" : "$context.routeKey", "path" : "$context.path" })
  }
}

# API Gateway Logs
resource "aws_cloudwatch_log_group" "gateway" {
  name              = "/aws/api-gateway/${local.service}-public-log-group-${local.env}"
  retention_in_days = "30"
}
