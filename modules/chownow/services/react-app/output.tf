output "lambda_arn" {
  description = "The arn of the lambda"
  value       = aws_lambda_function.lambda-s3-cleanup.arn
}

output "lambda_version" {
  description = "The version of the lambda"
  value       = aws_lambda_function.lambda-s3-cleanup.version
}
