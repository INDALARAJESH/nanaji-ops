resource "aws_sns_topic" "pm_status" {
  name = local.name
}

resource "aws_sns_topic_subscription" "pm_email_subscription" {
  for_each  = toset(local.notify_list)
  topic_arn = aws_sns_topic.pm_status.arn
  protocol  = "email"
  endpoint  = each.value
}
