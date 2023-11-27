resource "aws_cloudwatch_event_rule" "root_login" {
  name        = "${var.service}-${local.env}"
  description = "Alert on Root account logins"

  event_pattern = <<EOF
{
  "detail-type": [
    "AWS Console Sign In via CloudTrail"
  ],
  "detail": {
    "userIdentity": {
      "type": [
        "Root"
      ]
    }
  }
}
EOF
  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-${local.env}" }
  )
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.root_login.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.root_login.arn
}

resource "aws_cloudwatch_event_target" "cloudwatch_logs" {
  rule      = aws_cloudwatch_event_rule.root_login.name
  target_id = "SendToCloudWatchLogs"
  arn       = aws_cloudwatch_log_group.root_login_event_log_group.arn
}
