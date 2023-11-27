variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance name"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "cloudwatch2datadog"
}

locals {
  env = "${var.env}${var.env_inst}"

  lambda_layer_names = [
    "python3_cloudwatch_logs_${local.env}_useast1",
    "python3_chownow_common_${local.env}_useast1",
  ]

  dd_api_key_secret_path = "${local.env}/datadog/ops_api_key"
}
