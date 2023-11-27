output "lambda_function_arn" {
  description = "Lambda function arn"
  value       = local.lambda_ecr.arn
}

output "lambda_function_arn_alias_newest" {
  description = "Lambda function alias arn"
  value       = concat(aws_lambda_alias.newest.*.arn, [""])[0]
}

output "lambda_function_invoke_arn" {
  description = "Lambda function invoke arn"
  value       = local.lambda_ecr.invoke_arn
}

output "lambda_function_invoke_arn_alias_newest" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri -- alias that points to the specified Lambda function version."
  value       = concat(aws_lambda_alias.newest.*.invoke_arn, [""])[0]
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = local.lambda_ecr.id
}

output "lambda_base_name" {
  description = "Lambda function base name"
  value       = var.lambda_name
}

output "lambda_iam_role_id" {
  description = "exposing lambda iam role id for iam attachment that use id"
  value       = aws_iam_role.lambda_role.id
}

output "lambda_iam_role_name" {
  description = "exposing lambda iam role to enable attaching custom policies"
  value       = aws_iam_role.lambda_role.name
}

output "aws_cloudwatch_log_group_name" {
  description = "lambda function cloudwatch log_group name"
  value       = aws_cloudwatch_log_group.lamdba.name
}
