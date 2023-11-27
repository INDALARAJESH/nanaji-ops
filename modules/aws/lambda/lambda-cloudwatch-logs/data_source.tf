# Data source lookups
data "aws_cloudwatch_log_group" "log_group" {
  name = var.cloudwatch_log_group_name
}

data "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
}
