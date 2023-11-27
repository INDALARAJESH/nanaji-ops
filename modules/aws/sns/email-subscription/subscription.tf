resource "aws_sns_topic_subscription" "sns-topic" {
  topic_arn     = data.aws_sns_topic.topic.arn
  protocol      = "email"
  endpoint      = var.email
  filter_policy = var.filter_policy
}
