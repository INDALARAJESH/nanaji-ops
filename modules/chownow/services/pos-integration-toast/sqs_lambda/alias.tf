resource "aws_lambda_alias" "handler_alias" {
  name             = "newest"
  description      = aws_lambda_function.handler.description
  function_name    = aws_lambda_function.handler.function_name
  function_version = aws_lambda_function.handler.version
}
