resource "aws_api_gateway_resource" "root" {
  parent_id   = data.aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.path_prefix
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_resource" "api" {
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "{proxy+}"
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "api" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.api.id
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "api" {
  rest_api_id             = data.aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api.id
  http_method             = aws_api_gateway_method.api.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
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
      aws_api_gateway_resource.api.id,
      aws_api_gateway_method.api.id,
      aws_api_gateway_integration.api.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "default" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
  stage_name    = "default"

  dynamic "access_log_settings" {
    for_each = var.access_log_settings

    content {
      destination_arn = access_log_settings.value.destination_arn
      format          = access_log_settings.value.format
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}
