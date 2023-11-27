resource "aws_lambda_alias" "scheduled_alias" {
  name             = "newest"
  description      = aws_lambda_function.scheduled_lambda.description
  function_name    = aws_lambda_function.scheduled_lambda.function_name
  function_version = aws_lambda_function.scheduled_lambda.version
}
