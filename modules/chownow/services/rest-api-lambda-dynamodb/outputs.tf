output "lambda_iam_role_name" {
  description = "exposing lambda iam role to enable attaching custom policies"
  value       = module.api_lambda.lambda_iam_role_name
}

output "api_gateway_stage_id" {
  description = "stage id of api gateway"
  value       = module.api_lambda.api_gateway_stage_id
}

output "api_gateway_stage_arn" {
  description = "stage arn of api gateway"
  value       = module.api_lambda.api_gateway_stage_arn
}

output "api_gateway_stage_name" {
  description = "stage name of api gateway"
  value       = module.api_lambda.api_gateway_stage_name
}
