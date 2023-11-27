output "api_id" {
  description = "id of api gateway forcing the rest_api_policy to be created before deployment"
  value       = aws_api_gateway_rest_api_policy.api.id
}

output "openapi_spec_checksum" {
  description = "Checksum of OpenAPI specification that defines the set of routes and integrations to create as part of the REST API"
  value       = sha1(aws_api_gateway_rest_api.api.body)
}

output "api_gw_resource_policy_checksum" {
  description = "Checksum of API Gateway Resource policy"
  value       = sha1(data.aws_iam_policy_document.api_gw_resource_policy.json)
}