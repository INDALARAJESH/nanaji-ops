resource "aws_cloudwatch_log_group" "sysdig_ecs_orchestrator" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_days

  tags = local.common_tags
}
