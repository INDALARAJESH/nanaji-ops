# Root API endpoint

resource "aws_api_gateway_resource" "root" {
  parent_id   = data.aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "v1"
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_resource" "data_requests" {
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "data-requests"
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "data_requests_post" {
  authorization    = "NONE"
  http_method      = "POST"
  resource_id      = aws_api_gateway_resource.data_requests.id
  rest_api_id      = data.aws_api_gateway_rest_api.api.id
  api_key_required = true
}

resource "aws_api_gateway_api_key" "user_privacy_service_api_key" {
  name = "user_privacy_service_api_key"
}

resource "aws_api_gateway_usage_plan" "user_privacy_service_api_usage_plan" {
  name = "usage_${local.app_name}"

  api_stages {
    api_id = data.aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_stage.api.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "user_privacy_service_api_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.user_privacy_service_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.user_privacy_service_api_usage_plan.id
}

resource "aws_api_gateway_integration" "api_data_requests_post" {
  rest_api_id             = data.aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.data_requests.id
  http_method             = aws_api_gateway_method.data_requests_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.user_privacy_lambda.lambda_function_invoke_arn
}

resource "aws_lambda_permission" "api_gw_user_privacy_service" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.user_privacy_lambda.lambda_function_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${data.aws_api_gateway_rest_api.api.id}/*/*${aws_api_gateway_resource.data_requests.path}"

}

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
      aws_api_gateway_resource.data_requests.id,
      aws_api_gateway_method.data_requests_post.id,
      aws_api_gateway_integration.api_data_requests_post.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
  stage_name    = local.env

  dynamic "access_log_settings" {
    for_each = local.access_log_settings

    content {
      destination_arn = access_log_settings.value.destination_arn
      format          = access_log_settings.value.format
    }
  }
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = data.aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = data.aws_api_gateway_domain_name.this_public.domain_name
}

resource "aws_api_gateway_rest_api_policy" "gateway_policy" {
  rest_api_id = data.aws_api_gateway_rest_api.api.id

  # the first set of IPs is Cloudflare, the second is our VPN

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "*",
            "Condition": {
                "NotIpAddress": {
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
