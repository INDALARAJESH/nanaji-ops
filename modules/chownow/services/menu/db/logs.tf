resource "aws_cloudwatch_log_subscription_filter" "audit" {
  name            = "datadog-log-audit-menu-${local.env}"
  log_group_name  = "/aws/rds/cluster/menu-mysql-${local.env}/audit"
  destination_arn = data.aws_lambda_function.datadog_log_forwarder.arn
  filter_pattern  = ""
  depends_on      = [module.menu_aurora]
}

resource "aws_cloudwatch_log_subscription_filter" "error" {
  name            = "datadog-log-error-menu-${local.env}"
  log_group_name  = "/aws/rds/cluster/menu-mysql-${local.env}/error"
  destination_arn = data.aws_lambda_function.datadog_log_forwarder.arn
  filter_pattern  = ""
  depends_on      = [module.menu_aurora]
}
