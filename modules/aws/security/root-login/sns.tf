resource "aws_sns_topic" "root_login" {
  name = "${var.service}-${local.env}"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-${local.env}" }
  )
}

resource "aws_sns_topic_policy" "root_login" {
  arn    = aws_sns_topic.root_login.arn
  policy = data.aws_iam_policy_document.root_login_event_policy.json
}

resource "aws_sns_topic_subscription" "root_login_email" {
  for_each = var.alert_subscription_emails

  topic_arn = aws_sns_topic.root_login.arn
  protocol  = "email"
  endpoint  = each.value
}
