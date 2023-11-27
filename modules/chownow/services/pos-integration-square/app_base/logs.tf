# Lambda to forward to Datadog
module "datadog_log_forward" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/log-forwarder?ref=aws-datadog-log-forwarder-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = local.app_name
}

# API Gateway Logs
resource "aws_cloudwatch_log_group" "gateway" {
  name              = format("/aws/api-gateway/%s-log-group-%s", local.app_name, local.env)
  retention_in_days = "30"

  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("/aws/api-gateway/%s-log-group-%s", local.app_name, local.env),
    )
  )
}

# # Lambda to send API Gateway CloudWatch logs to datadog
resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward_api_gateway" {
  name            = format("datadog-log--api-gateway-%s-%s", local.app_name, local.env)
  log_group_name  = aws_cloudwatch_log_group.gateway.name
  destination_arn = format("arn:aws:lambda:%s:%s:function:%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, module.datadog_log_forward.name)
  filter_pattern  = ""

  depends_on = [module.datadog_log_forward]
}
