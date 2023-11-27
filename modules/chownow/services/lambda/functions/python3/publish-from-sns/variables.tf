variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "lambda"
}

variable "slack_webhook_secret_path" {
  description = "slack webhook secretsmanager secret path"
  default     = ""
}

locals {
  env                       = "${var.env}${var.env_inst}"
  slack_webhook_secret_path = var.slack_webhook_secret_path == "" ? "${local.env}/slack/webhook" : var.slack_webhook_secret_path
}
