module "cloudwatchlogs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-cloudwatch-logs?ref=cn-hermosa-db-v2.2.0&depth=1"
  count  = var.enable_cloudwatch_logs == 1 ? 1 : 0

  lambda_name               = local.cloudwatch2datadog_lambda
  cloudwatch_log_group_name = local.cloudwatch_log_group_name
}
