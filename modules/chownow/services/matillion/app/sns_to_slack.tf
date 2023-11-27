resource "aws_sns_topic_subscription" "sns_to_slack" {
  topic_arn              = data.aws_sns_topic.sns_to_slack.arn
  protocol               = "lambda"
  endpoint               = data.aws_lambda_function.sns_to_slack.arn
  endpoint_auto_confirms = true
}

resource "aws_lambda_permission" "sns_to_slack" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.sns_to_slack.arn
  principal     = "sns.amazonaws.com"
  source_arn    = data.aws_sns_topic.sns_to_slack.arn
}
