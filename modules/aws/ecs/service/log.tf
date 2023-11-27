resource "aws_cloudwatch_log_group" "app" {
  name              = "${local.service}-log-group-${local.env}"
  retention_in_days = var.log_retention_in_days

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.service}-log-group-${local.env}" }
  )
}
