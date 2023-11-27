resource "aws_sns_topic_subscription" "datadog_resto_events_subscription" {
  topic_arn              = data.aws_sns_topic.restaurant_events.arn
  protocol               = "https"
  endpoint               = local.dd_webhook_url
  endpoint_auto_confirms = true
}
