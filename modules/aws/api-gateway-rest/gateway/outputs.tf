output "api_id" {
  description = "id of api gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_root_resource_id" {
  description = "root resource id of api gateway"
  value       = aws_api_gateway_rest_api.api.root_resource_id
}
