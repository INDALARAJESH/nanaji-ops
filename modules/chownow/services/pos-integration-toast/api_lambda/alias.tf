resource "aws_lambda_alias" "api_alias" {
  name             = "newest"
  description      = aws_lambda_function.api.description
  function_name    = aws_lambda_function.api.function_name
  function_version = aws_lambda_function.api.version
}
