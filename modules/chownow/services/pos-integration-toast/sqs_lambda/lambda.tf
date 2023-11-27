resource "aws_lambda_function" "handler" {
  description   = "${var.handler_name} lambda handler"
  function_name = "${var.service}-${var.handler_name}-${var.env}"
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.handler.arn
  package_type  = "Image"
  image_uri     = "${var.image_repository_url}:${var.handler_lambda_image_tag}"
  timeout       = var.lambda_timeout
  publish       = true

  # If both subnet_ids and security_group_ids are empty then vpc_config is considered to be empty or unset.
  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#vpc_config
  vpc_config {
    subnet_ids         = var.lambda_vpc_subnet_ids
    security_group_ids = var.lambda_security_group_ids
  }

  environment {
    variables = var.environment_variables
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_iam_role" "handler" {
  name               = "${var.service}-${var.handler_name}-lambda-handler"
  description        = "${var.handler_name} lambda handler role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.handler.name
  policy_arn = aws_iam_policy.queue_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_base" {
  role       = aws_iam_role.handler.name
  policy_arn = var.lambda_base_policy_arn
}

resource "aws_iam_policy" "queue_policy" {
  name   = "${var.service}-${var.handler_name}-sqs-${var.env}"
  policy = data.aws_iam_policy_document.queue_policy_doc.json
}

data "aws_iam_policy_document" "queue_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:SendMessage"]
    resources = [aws_sqs_queue.queue.arn, aws_sqs_queue.failure_queue.arn]
  }
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
resource "aws_cloudwatch_log_group" "handler" {
  name              = "/aws/lambda/${aws_lambda_function.handler.function_name}"
  retention_in_days = var.cloudwatch_logs_retention
}
