resource "aws_lambda_function" "scheduled_lambda" {
  description   = "${var.lambda_name} scheduled lambda"
  function_name = "${var.service}-${var.lambda_name}-${var.env}"
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${var.image_repository_url}:${var.lambda_image_tag}"
  timeout       = var.lambda_timeout
  publish       = true

  environment {
    variables = var.environment_variables
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.service}-${var.lambda_name}-lambda-scheduled"
  description        = "${var.lambda_name} scheduled lambda role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "lambda_base" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.lambda_base_policy_arn
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# CloudWatch Log Group for Lambda fn
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.scheduled_lambda.function_name}"
  retention_in_days = var.cloudwatch_logs_retention
}

resource "aws_lambda_permission" "event_bridge_scheduler_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduled_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_lambda_event_rule.arn
  qualifier     = aws_lambda_alias.scheduled_alias.name
}
