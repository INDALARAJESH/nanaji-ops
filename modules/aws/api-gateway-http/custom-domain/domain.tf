# Domain name
resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = local.domain_name

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.cert.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    "Name" = local.domain_name
  }
}

# Mapping
resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = var.api_gateway_id
  stage       = var.api_gateway_stage_id
  domain_name = aws_apigatewayv2_domain_name.api.id
}
