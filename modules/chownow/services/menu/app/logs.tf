resource "aws_cloudwatch_log_subscription_filter" "performance" {
  name            = "datadog-log-performance-menu-${local.env}"
  log_group_name  = "/aws/ecs/containerinsights/menu-${local.env}/performance"
  destination_arn = data.aws_lambda_function.datadog_log_forwarder.arn
  filter_pattern  = ""
  depends_on      = [module.ecs_base_web]
}
