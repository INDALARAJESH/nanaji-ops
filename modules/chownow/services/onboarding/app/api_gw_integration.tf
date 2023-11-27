locals {
  access_control_allow_headers = "'*'"
  access_control_allow_methods = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
  access_control_allow_origin  = format("'%s'", var.cors_allow_origin_url)
}

# Root API endpoint

resource "aws_api_gateway_resource" "root" {
  parent_id   = data.aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "v1"
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_resource" "api_proxy" {
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "{proxy+}"
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "api_proxy" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.api_proxy.id
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "api_proxy" {
  rest_api_id             = data.aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_proxy.id
  http_method             = aws_api_gateway_method.api_proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.api_gateway_event_handler_lambda.lambda_function_invoke_arn
}

resource "aws_lambda_permission" "api_gateway_event_handler" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.api_gateway_event_handler_lambda.lambda_function_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${data.aws_api_gateway_rest_api.api.id}/*/*${aws_api_gateway_resource.api_proxy.path}"

}

# API GW OPTIONS method for CORS preflight

resource "aws_api_gateway_method" "api_gateway_event_handler_options" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_proxy.id
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method_response" "api_gateway_event_handler_options_200" {
  rest_api_id = data.aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_proxy.id
  http_method = "OPTIONS"
  status_code = 200
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.api_gateway_event_handler_options]
}

resource "aws_api_gateway_integration" "api_gateway_event_handler_options_integration" {
  rest_api_id = data.aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_proxy.id
  http_method = "OPTIONS"
  type        = "MOCK"
  request_templates = {
    "application/json" = "{ 'statusCode': 200 }"
  }
  depends_on = [aws_api_gateway_method.api_gateway_event_handler_options]
}

resource "aws_api_gateway_integration_response" "api_gateway_event_handler_options_integration_response" {
  rest_api_id = data.aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_proxy.id
  http_method = "OPTIONS"
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = local.access_control_allow_headers,
    "method.response.header.Access-Control-Allow-Methods" = local.access_control_allow_methods,
    "method.response.header.Access-Control-Allow-Origin"  = local.access_control_allow_origin
  }
  depends_on = [aws_api_gateway_method_response.api_gateway_event_handler_options_200]
}

# cors gateway responses 4XX 5XX

resource "aws_api_gateway_gateway_response" "cors_4xx" {
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = local.access_control_allow_headers
    "gatewayresponse.header.Access-Control-Allow-Methods" = local.access_control_allow_methods
    "gatewayresponse.header.Access-Control-Allow-Origin"  = local.access_control_allow_origin
  }
}

resource "aws_api_gateway_gateway_response" "cors_5xx" {
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = local.access_control_allow_headers
    "gatewayresponse.header.Access-Control-Allow-Methods" = local.access_control_allow_methods
    "gatewayresponse.header.Access-Control-Allow-Origin"  = local.access_control_allow_origin
  }
}


# deployment, stage, path mapping

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = data.aws_api_gateway_rest_api.api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_proxy.id,
      aws_api_gateway_method.api_proxy.id,
      aws_api_gateway_integration.api_proxy.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
  stage_name    = var.env

  cache_cluster_enabled = false
  # cache_cluster_size    = "0.5"

  dynamic "access_log_settings" {
    for_each = local.access_log_settings

    content {
      destination_arn = access_log_settings.value.destination_arn
      format          = access_log_settings.value.format
    }
  }
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = data.aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  method_path = "*/*"

  settings {
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = data.aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = data.aws_api_gateway_domain_name.this_public.domain_name
}

resource "aws_api_gateway_rest_api_policy" "test" {
  rest_api_id = data.aws_api_gateway_rest_api.api.id

  count = var.env == "ncp" ? 0 : 1

  # the first set of IPs is Cloudflare, the second is our VPN

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "173.245.48.0/20",
                        "103.21.244.0/22",
                        "103.22.200.0/22",
                        "103.31.4.0/22",
                        "141.101.64.0/18",
                        "108.162.192.0/18",
                        "190.93.240.0/20",
                        "188.114.96.0/20",
                        "197.234.240.0/22",
                        "198.41.128.0/17",
                        "162.158.0.0/15",
                        "104.16.0.0/13",
                        "104.24.0.0/14",
                        "172.64.0.0/13",
                        "131.0.72.0/22",
                        "54.183.225.53/32",
                        "54.183.68.210/32",
                        "52.6.18.116/32",
                        "54.227.163.228/32",
                        "52.21.177.104/32",
                        "34.224.187.148/32"
                    ]
                }
            }
        }
  ]
}
EOF
}
