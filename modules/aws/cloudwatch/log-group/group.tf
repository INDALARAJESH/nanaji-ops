resource "aws_cloudwatch_log_group" "main" {
  name              = "${local.name}-logs"
  kms_key_id        = var.kms_key_id
  retention_in_days = var.retention_in_days
  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.name}-logs" }
  )
}
