resource "aws_api_gateway_rest_api" "api" {
  name = var.name

  body = var.openapi_spec_json

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = var.name }
  )
}

resource "aws_api_gateway_rest_api_policy" "api" {
  count       = var.resource_policy_enabled ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api.id
  policy      = data.aws_iam_policy_document.api_gw_resource_policy.json
}
