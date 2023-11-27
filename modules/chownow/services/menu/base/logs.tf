module "datadog_log_forward" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/log-forwarder?ref=aws-datadog-log-forwarder-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
