variable "service" {
  description = "unique service name for project/application"
  default     = "mds-order-delivery-messages"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance"
  default     = ""
}

variable "sns_lambda_success_feedback_sample_rate" {
  description = "SNS lambda success feedback sample rate"
  default     = 100
}

variable "sns_cross_account_access_arn" {
  description = "ARN to allow topic subscription"
  default     = ""
}

locals {
  env = "${var.env}${var.env_inst}"

  sns_topic_name = "cn-order-delivery-events-${local.env}"
}
