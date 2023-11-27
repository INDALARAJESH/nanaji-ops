data "aws_caller_identity" "current" {}

data "aws_lambda_function" "datadog_log_forwarder" {
  function_name = "datadog-forwarder-${var.service}-${local.env}"
}
