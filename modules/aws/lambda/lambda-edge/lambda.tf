resource "aws_lambda_function" "lambda" {
  description   = var.lambda_description
  function_name = var.lambda_name
  handler       = var.lambda_handler
  layers        = data.aws_lambda_layer_version.layers.*.arn
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.lambda_role.arn
  runtime       = var.lambda_runtime
  s3_bucket     = local.s3_bucket
  s3_key        = local.s3_key
  timeout       = var.lambda_timeout

  tags = {
    Managed_By  = var.lambda_tag_managed_by
    Lambda_Name = var.lambda_name
    Region      = var.aws_region
    Service     = var.service
  }

  lifecycle {
    ignore_changes = [s3_bucket, s3_key]
  }
}

# Lookup lambda layer arns
data "aws_lambda_layer_version" "layers" {
  count      = length(var.lambda_layer_names)
  layer_name = var.lambda_layer_names[count.index]
}

# CloudWatch Log Group for Lambda fn
resource "aws_cloudwatch_log_group" "lamdba" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = var.cloudwatch_logs_retention
}

resource "aws_lambda_alias" "lambda" {
  name             = "latest"
  function_name    = aws_lambda_function.lambda.arn
  function_version = aws_lambda_function.lambda.version
}
