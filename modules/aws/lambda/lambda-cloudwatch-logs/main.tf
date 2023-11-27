# Give cloudwatch logs permission to invoke the function

resource "aws_lambda_permission" "cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn    = data.aws_cloudwatch_log_group.log_group.arn
}

# Create subscription filter that will be called upon new CloudWatch entries

resource "aws_cloudwatch_log_subscription_filter" "filter" {
  name = "${var.lambda_name}-subscription-filter"

  filter_pattern  = var.cloudwatch_log_subscription_filter_pattern
  destination_arn = data.aws_lambda_function.lambda.arn
  log_group_name  = var.cloudwatch_log_group_name
}
