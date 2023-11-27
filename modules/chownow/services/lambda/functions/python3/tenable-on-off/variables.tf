data "aws_caller_identity" "current" {}

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

variable "on_cron" {
  description = "cron expression for when to turn the Tenable instances on"
  default     = "cron(0 3 ? * 4 *)"
}

variable "off_cron" {
  description = "cron expression for when to turn the Tenable instances off"
  default     = "cron(0 8 ? * 4 *)"
}

locals {
  env = "${var.env}${var.env_inst}"
  lambda_layer_names = [
    "python3_chownow_common_${var.env}_useast1"
  ]
}
