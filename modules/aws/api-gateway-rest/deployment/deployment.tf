resource "aws_api_gateway_deployment" "api" {
  rest_api_id = var.api_id

  triggers = {
    redeployment = sha1(jsonencode(
      var.redeployment_trigger
    ))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = var.api_id
  stage_name    = "api"

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

resource "random_string" "default_api_key_name" {
  count   = var.create_api_key ? 1 : 0
  length  = 16
  number  = true
  lower   = true
  upper   = false
  special = false
}

resource "aws_api_gateway_api_key" "default" {
  count       = var.create_api_key ? 1 : 0
  name        = random_string.default_api_key_name[0].result
  description = format("%s@%s -- Managed by Terraform", var.api_id, aws_api_gateway_stage.api.stage_name) # defaults to "Managed by Terraform"
  # enabled     = bool # defaults to true
  # value       = str  # if not specified it'll be automatically generated by AWS on creation

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_api_gateway_usage_plan" "default" {
  count = var.create_api_key ? 1 : 0
  name  = "default"
  api_stages {
    api_id = var.api_id
    stage  = aws_api_gateway_stage.api.stage_name
  }

  # quota / throttle settings unlimited by default

  # quota_settings {
  #   limit  = 20
  #   offset = 2
  #   period = "WEEK"
  # }

  # throttle_settings {
  #   burst_limit = 5
  #   rate_limit  = 10
  # }
}

resource "aws_api_gateway_usage_plan_key" "default" {
  count         = var.create_api_key ? 1 : 0
  key_id        = aws_api_gateway_api_key.default[0].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.default[0].id

  # Forcing dependency, this usage_plan/key mapping sometimes gets lost after redeployment
  depends_on = [
    aws_api_gateway_deployment.api,
    aws_api_gateway_stage.api
  ]
}