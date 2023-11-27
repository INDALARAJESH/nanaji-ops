resource "aws_api_gateway_rest_api" "api" {
  name = var.name

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = var.name }
  )
}
