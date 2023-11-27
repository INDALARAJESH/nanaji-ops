output "target_domain_name" {
  description = "gateway target domain"
  value       = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
}

output "hosted_zone_id" {
  description = "gateway domain zone"
  value       = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
}
