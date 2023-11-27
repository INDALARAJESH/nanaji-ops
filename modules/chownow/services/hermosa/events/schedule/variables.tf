variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "Environment Instance"
}

variable "service" {
  default = "hermosa-schedule"
}

variable "target_sqs_queue_name" {
  description = "name of the target SQS queue"
  default     = "hermosa-events"
}

variable "schedule_item_enabled_disabled" {
  description = "enable or disable scheduled items"
  default     = "ENABLED"
}

locals {
  env = "${var.env}${var.env_inst}"

  target_sqs_queue_name = "${var.target_sqs_queue_name}_${local.env}"
}
