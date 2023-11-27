resource "aws_cloudwatch_log_group" "root_login_event_log_group" {
  name              = local.log_group_name
  retention_in_days = 30

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.log_group_name }
  )
}

resource "aws_cloudwatch_log_resource_policy" "event_logs_policy" {
  policy_document = data.aws_iam_policy_document.login_event_logs_policy.json
  policy_name     = "${var.service}-${local.env}"
}

