module "mul_2fa_gateway" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-http/gateway?ref=aws-api-gateway-http-gateway-v2.0.1"

  env  = local.env
  name = var.mul_2fa_api_gateway_name

  access_log_settings = [
    {
      destination_arn = module.mul_2fa_api_gw_log_group.arn

      format = jsonencode({
        requestId               = "$context.requestId"
        sourceIp                = "$context.identity.sourceIp"
        requestTime             = "$context.requestTime"
        protocol                = "$context.protocol"
        httpMethod              = "$context.httpMethod"
        resourcePath            = "$context.resourcePath"
        routeKey                = "$context.routeKey"
        status                  = "$context.status"
        responseLength          = "$context.responseLength"
        integrationErrorMessage = "$context.integrationErrorMessage"
        }
      )
    }
  ]

}

module "mul_2fa_gw_lambda_integration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-http/lambda-integration?ref=aws-api-gateway-http-lambda-integration-v2.0.0"

  api_id                     = module.mul_2fa_gateway.api_id
  lambda_arn                 = module.mulholland_2fa_integration_lambda.lambda_function_arn
  lambda_invoke_arn          = module.mulholland_2fa_integration_lambda.lambda_function_invoke_arn
  payload_format_version     = "1.0"
  enable_default_route       = 0
  source_arn_permission_path = "/*/*"
}

resource "aws_apigatewayv2_route" "mul_2fa_route" {
  api_id    = module.mul_2fa_gateway.api_id
  route_key = "POST /2fa"
  target    = "integrations/${module.mul_2fa_gw_lambda_integration.id}"
}
