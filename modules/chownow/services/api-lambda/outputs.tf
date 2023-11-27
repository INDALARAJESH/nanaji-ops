output "lambda_iam_role_name" {
  description = "exposing lambda iam role to enable attaching custom policies"
  value       = module.function.lambda_iam_role_name
}

output "api_gateway_id" {
  description = "id of api gateway"
  value       = module.http_api_gateway.api_id
}

output "api_gateway_stage_id" {
  description = "stage id of api gateway"
  value       = module.http_api_gateway.stage_id
}

output "api_gateway_stage_arn" {
  description = "stage arn of api gateway"
  value       = module.http_api_gateway.stage_arn
}
