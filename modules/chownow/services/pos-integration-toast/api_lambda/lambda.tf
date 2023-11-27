resource "aws_lambda_function" "api" {
  description   = "${var.api_lambda_name} api lambda"
  function_name = "${var.service}-${var.api_lambda_name}-${var.env}"
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.api.arn
  package_type  = "Image"
  image_uri     = "${var.image_repository_url}:${var.api_lambda_image_tag}"
  timeout       = var.lambda_timeout
  publish       = true

  environment {
    variables = var.environment_variables
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_iam_role" "api" {
  name               = "${var.service}-${var.api_lambda_name}-lambda-api"
  description        = "${var.api_lambda_name} lambda api role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "lambda_base" {
  role       = aws_iam_role.api.name
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
resource "aws_cloudwatch_log_group" "api" {
  name              = "/aws/lambda/${aws_lambda_function.api.function_name}"
  retention_in_days = var.cloudwatch_logs_retention
}

# permission to api gateway to invoke the api lambda
resource "aws_lambda_permission" "api-gw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.arn
  principal     = "apigateway.amazonaws.com"
  qualifier     = aws_lambda_alias.api_alias.name

  source_arn = "${var.api_gw_execution_arn}/*/${var.resource_path}"

}
