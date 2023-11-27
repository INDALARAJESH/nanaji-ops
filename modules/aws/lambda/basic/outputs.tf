output "lambda_bucket_name" {
  description = "Lambda artifact/zip storage bucket"
  value       = var.lambda_s3 ? aws_s3_bucket.lambda_artifacts[0].id : ""
}

output "lambda_function_arn" {
  description = "Lambda function arn"
  value       = var.lambda_s3 ? aws_lambda_function.lambda_s3[0].arn : aws_lambda_function.lambda_ecr[0].arn
}

output "lambda_function_arn_alias_newest" {
  description = "Lambda function alias arn"
  value       = concat(aws_lambda_alias.newest.*.arn, [""])[0]
}

output "lambda_function_invoke_arn" {
  description = "Lambda function invoke arn"
  value       = var.lambda_s3 ? aws_lambda_function.lambda_s3[0].invoke_arn : aws_lambda_function.lambda_ecr[0].invoke_arn
}

output "lambda_function_invoke_arn_alias_newest" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri -- alias that points to the specified Lambda function version."
  value       = concat(aws_lambda_alias.newest.*.invoke_arn, [""])[0]
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = var.lambda_s3 ? aws_lambda_function.lambda_s3[0].id : aws_lambda_function.lambda_ecr[0].id
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
