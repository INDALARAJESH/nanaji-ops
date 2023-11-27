# forward to Datadog

module "datadog_log_forward" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/log-forwarder?ref=aws-datadog-log-forwarder-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward_filter" {
  name            = "datadog-log-${var.service}-${local.env}"
  log_group_name  = module.loyalty_ecs.cloudwatch_log_group_name
  destination_arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${module.datadog_log_forward.name}"
  filter_pattern  = ""
  depends_on      = [module.datadog_log_forward]
}

# Lambda to send Lambda CloudWatch logs to datadog
resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward_lambda_salesforce" {
  name            = "datadog-log-salesforce-${var.service}-${local.env}"
  log_group_name  = "/aws/lambda/${local.salesforce_lambda_classification}"
  destination_arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${module.datadog_log_forward.name}"
  filter_pattern  = ""
  depends_on = [
    module.datadog_log_forward,
    module.loyalty_salesforce_lambda
  ]
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward_lambda_sqs" {
  name            = "datadog-log-sqs-${var.service}-${local.env}"
  log_group_name  = "/aws/lambda/${local.sqs_lambda_classification}"
  destination_arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${module.datadog_log_forward.name}"
  filter_pattern  = ""
  depends_on = [
    module.datadog_log_forward,
    module.loyalty_sqs_lambda
  ]
}
