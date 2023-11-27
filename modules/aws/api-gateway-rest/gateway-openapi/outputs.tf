output "api_id" {
  description = "id of api gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "openapi_spec_checksum" {
  description = "Checksum of OpenAPI specification that defines the set of routes and integrations to create as part of the REST API"
  value       = sha1(aws_api_gateway_rest_api.api.body)
}