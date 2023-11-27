output "lambda_role_arn" {
  description = "the arn of the scheduled lambda's role"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_role_name" {
  description = "the name of the scheduled lambda's role"
  value       = aws_iam_role.lambda_role.name
}

output "lambda_arn" {
  description = "the arn of the scheduled lambda"
  value       = aws_lambda_function.scheduled_lambda.arn
}

output "lambda_name" {
  description = "the name of the scheduled lambda"
  value       = aws_lambda_function.scheduled_lambda.function_name
}

output "lambda_alias_invoke_arn" {
  description = "lambda alias invoke arn"
  value       = aws_lambda_alias.scheduled_alias.invoke_arn
}
