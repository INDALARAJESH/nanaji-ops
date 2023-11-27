module "root_login" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security/root-login?ref=aws-security-root-login-v2.0.0"

  env = local.env
}

module "datadog_log_forward" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/log-forwarder?ref=aws-datadog-log-forwarder-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward" {
  name            = "datadog-log-${var.service}-${local.env}"
  log_group_name  = module.root_login.log_group_name
  destination_arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:datadog-forwarder-${var.service}-${local.env}"
  filter_pattern  = ""

  depends_on = [module.root_login]
}
