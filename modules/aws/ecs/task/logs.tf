resource "aws_cloudwatch_log_group" "task" {
  count = var.cwlog_group_name == "" ? 0 : 1

  name              = var.cwlog_group_name
  retention_in_days = var.cwlog_retention_in_days

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = var.cwlog_group_name }
  )
}
