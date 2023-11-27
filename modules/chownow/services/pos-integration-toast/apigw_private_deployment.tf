# Module for public-facing API Gateway deployment

resource "aws_api_gateway_deployment" "private_api" {
  rest_api_id = aws_api_gateway_rest_api.private_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.private_api.body,
      data.aws_iam_policy_document.private_api,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "private_api" {
  deployment_id = aws_api_gateway_deployment.private_api.id
  rest_api_id   = aws_api_gateway_rest_api.private_api.id
  stage_name    = "api"


  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.private_gateway.arn
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "caller" : "$context.identity.caller", "user" : "$context.identity.user", "requestTime" : "$context.requestTime", "httpMethod" : "$context.httpMethod", "resourcePath" : "$context.resourcePath", "status" : "$context.status", "protocol" : "$context.protocol", "responseLength" : "$context.responseLength", "userAgent" : "$context.identity.userAgent", "integrationError" : "$context.integration.error", "sourceIp" : "$context.identity.sourceIp", "routeKey" : "$context.routeKey", "path" : "$context.path" })
  }
}

# API Gateway Logs
resource "aws_cloudwatch_log_group" "private_gateway" {
  name              = "/aws/api-gateway/${local.service}-private-log-group-${local.env}"
  retention_in_days = "30"
}

resource "aws_api_gateway_api_key" "private_api" {
  name        = "${local.service}-private-${local.env}"
  description = "API key for ${local.service} private api gateway"
}

resource "aws_api_gateway_usage_plan" "private_api" {
  name = "default"
  api_stages {
    api_id = aws_api_gateway_rest_api.private_api.id
    stage  = aws_api_gateway_stage.private_api.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "private_api" {
  key_id        = aws_api_gateway_api_key.private_api.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.private_api.id

  depends_on = [
    aws_api_gateway_deployment.private_api,
    aws_api_gateway_stage.private_api
  ]
}
