resource "aws_cloudwatch_event_rule" "scheduled_lambda_event_rule" {
  name                = "${var.service}-${var.lambda_name}-${var.env}"
  description         = "Scheduled Lambda event rule"
  schedule_expression = var.event_bridge_schedule_expression
}

resource "aws_cloudwatch_event_target" "profile_generator_lambda_target" {
  arn  = aws_lambda_alias.scheduled_alias.arn
  rule = aws_cloudwatch_event_rule.scheduled_lambda_event_rule.name
}
