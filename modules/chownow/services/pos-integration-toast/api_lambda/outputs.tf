output "api_lambda_role_arn" {
  description = "the arn of the api lambda's role"
  value       = aws_iam_role.api.arn
}

output "api_lambda_role_name" {
  description = "the name of the api lambda's role"
  value       = aws_iam_role.api.name
}

output "api_lambda_arn" {
  description = "the arn of the api lambda"
  value       = aws_lambda_function.api.arn
}

output "api_lambda_name" {
  description = "the name of the api lambda"
  value       = aws_lambda_function.api.function_name
}

output "lambda_alias_invoke_arn" {
  description = "the name of the api lambda"
  value       = aws_lambda_alias.api_alias.invoke_arn
}
