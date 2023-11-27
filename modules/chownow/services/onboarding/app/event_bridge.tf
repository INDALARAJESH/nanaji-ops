resource "aws_cloudwatch_event_bus" "sfdc_appflow_event_bus" {
  name              = data.aws_cloudwatch_event_source.sfdc_appflow_event_source.name
  event_source_name = data.aws_cloudwatch_event_source.sfdc_appflow_event_source.name
  depends_on        = [aws_appflow_flow.salesforce_flow]
}

resource "aws_cloudwatch_event_rule" "sfdc_appflow_event_rule" {
  name        = "${var.service}-sfdc-appflow-event-rule"
  description = "Trigger the Onboarding Service AppFlow lambda"

  event_bus_name = aws_cloudwatch_event_bus.sfdc_appflow_event_bus.name
  event_pattern = jsonencode({
    source = [{
      "prefix" : data.aws_cloudwatch_event_source.sfdc_appflow_event_source.name
    }]
    detail-type = var.sfdc_appflow_subscribed_event_names
  })
}

resource "aws_cloudwatch_event_target" "sfdc_appflow_event_target" {
  rule      = aws_cloudwatch_event_rule.sfdc_appflow_event_rule.name
  target_id = "TargetOnboardingAppFlowLambda"
  arn       = module.event_bridge_event_handler_lambda.lambda_function_arn

  event_bus_name = aws_cloudwatch_event_bus.sfdc_appflow_event_bus.name
}
