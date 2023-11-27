# Create a timer that runs on specified schedule
resource "aws_cloudwatch_event_rule" "lambda" {
  count = var.lambda_cron_boolean ? 1 : 0

  name                = "${local.lambda_classification}_timer"
  schedule_expression = var.cloudwatch_schedule_expression
}

# CloudWatch Log Group for Lambda fn
resource "aws_cloudwatch_log_group" "lamdba" {
  name              = "/aws/lambda/${local.lambda_classification}"
  retention_in_days = var.cloudwatch_logs_retention
}

# Lambda Image with lifecycle settings
resource "aws_lambda_function" "lambda_static_image" {
  count         = var.with_lifecycle ? 1 : 0
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

  lifecycle {
    ignore_changes = [image_uri]
  }
}

# Lambda Image without lifecycle settings
resource "aws_lambda_function" "lambda_dynamic_image" {
  count         = var.with_lifecycle ? 0 : 1
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
}

# Specify the lambda function to run
resource "aws_cloudwatch_event_target" "lambda_ecr" {
  count = var.lambda_cron_boolean ? 1 : 0

  rule = aws_cloudwatch_event_rule.lambda[0].name
  arn  = local.lambda_ecr.arn
}

# Give cloudwatch permission to invoke the function
resource "aws_lambda_permission" "permission_ecr" {
  count = var.lambda_cron_boolean ? 1 : 0

  action        = "lambda:InvokeFunction"
  function_name = local.lambda_ecr.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[0].arn
}
