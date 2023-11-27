# Create a timer that runs every 24 hours
resource "aws_cloudwatch_event_rule" "lambda" {
  count = var.lambda_cron_boolean ? 1 : 0

  name                = format("%s_timer", local.lambda_classification)
  schedule_expression = var.cloudwatch_schedule_expression
}

# CloudWatch Log Group for Lambda fn
resource "aws_cloudwatch_log_group" "lamdba" {
  name              = format("/aws/lambda/%s", local.lambda_classification)
  retention_in_days = var.cloudwatch_logs_retention
}

# Lambda with code on S3
resource "aws_lambda_function" "lambda_s3" {
  count         = var.lambda_s3 ? 1 : 0
  description   = var.lambda_description
  function_name = local.lambda_classification
  handler       = var.lambda_handler
  layers        = data.aws_lambda_layer_version.layers.*.arn
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.lambda_role.arn
  runtime       = var.lambda_runtime
  package_type  = "Zip"
  s3_bucket     = aws_s3_bucket.lambda_artifacts[0].id
  s3_key        = aws_s3_bucket_object.first_lambda_zip[0].id
  timeout       = var.lambda_timeout
  publish       = var.lambda_publish

  environment {
    variables = merge(
      local.lambda_env_variables,
      var.lambda_env_variables
    )
  }

  tags = merge(
    local.common_tags,
    local.datadog_tags,
    var.extra_tags
  )

  lifecycle {
    ignore_changes = [s3_bucket, s3_key]
  }
}

# Specify the lambda function to run
resource "aws_cloudwatch_event_target" "lambda_s3" {
  count = var.lambda_s3 && var.lambda_cron_boolean ? 1 : 0

  rule = aws_cloudwatch_event_rule.lambda[0].name
  arn  = aws_lambda_function.lambda_s3[0].arn
}

# Give cloudwatch permission to invoke the function
resource "aws_lambda_permission" "permission_s3" {
  count = var.lambda_s3 && var.lambda_cron_boolean ? 1 : 0

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_s3[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[0].arn
}

# Lambda with code in ECR image
resource "aws_lambda_function" "lambda_ecr" {
  count         = var.lambda_ecr ? 1 : 0
  description   = var.lambda_description
  function_name = local.lambda_classification
  layers        = data.aws_lambda_layer_version.layers.*.arn
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = var.lambda_image_uri
  timeout       = var.lambda_timeout
  publish       = var.lambda_publish

  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  image_config {
    command     = var.lambda_image_config_cmd
    entry_point = var.lambda_image_entry_point
    # working_directory = 
  }

  # If both `subnet_ids` and `security_group_ids` are empty then `vpc_config` is considered to be empty or unset.
  vpc_config {
    subnet_ids         = var.lambda_vpc_subnet_ids
    security_group_ids = var.lambda_vpc_sg_ids
  }

  tracing_config {
    mode = var.lambda_tracing_enabled ? "Active" : "PassThrough"
  }

  environment {
    variables = merge(
      local.lambda_env_variables,
      var.lambda_env_variables
    )
  }

  tags = merge(
    local.common_tags,
    local.datadog_tags,
    var.extra_tags
  )

  # Adding this back to enable channels-data in NCP (OPS-3343)
  lifecycle {
    ignore_changes = [image_uri]
  }
}

# Specify the lambda function to run
resource "aws_cloudwatch_event_target" "lambda_ecr" {
  count = var.lambda_ecr && var.lambda_cron_boolean ? 1 : 0

  rule = aws_cloudwatch_event_rule.lambda[0].name
  arn  = aws_lambda_function.lambda_ecr[0].arn
}

# Give cloudwatch permission to invoke the function
resource "aws_lambda_permission" "permission_ecr" {
  count = var.lambda_ecr && var.lambda_cron_boolean ? 1 : 0

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_ecr[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[0].arn
}
