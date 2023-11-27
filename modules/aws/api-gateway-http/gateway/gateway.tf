resource "aws_apigatewayv2_api" "api" {
  name          = var.name
  protocol_type = "HTTP"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = var.name }
  )
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true

  dynamic "access_log_settings" {
    for_each = var.access_log_settings

    content {
      destination_arn = access_log_settings.value.destination_arn
      format          = access_log_settings.value.format
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = var.name }
  )
}
