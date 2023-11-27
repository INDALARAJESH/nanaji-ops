variable "enable_sns_fifo_topic" {
  description = "enables/disables SNS first in first out"
  default     = true
}

variable "sns_lambda_success_feedback_sample_rate" {
  description = "SNS lambda success feedback sample rate"
  default     = 100
}


locals {
  sns_topic_name = var.enable_sns_fifo_topic ? "cn-${var.service}-events-${local.env}.fifo" : "cn-${var.service}-events-${local.env}"
}
