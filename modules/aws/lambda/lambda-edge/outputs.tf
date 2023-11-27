output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.lambda.id
}

output "lambda_iam_role" {
  description = "exposing lambda iam role to enable attaching custom policies"
  value       = aws_iam_role.lambda_role.id
}
