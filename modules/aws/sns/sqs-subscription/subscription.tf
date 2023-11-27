resource "aws_sns_topic_subscription" "sns_topic" {
  protocol             = "sqs"
  raw_message_delivery = var.raw_message_delivery
  topic_arn            = var.sns_topic_arn
  endpoint             = var.sqs_queue_arn
  filter_policy        = var.filter_policy
}
