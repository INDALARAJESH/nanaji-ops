variable "sns_topic_name" {
  description = "name of sns topic"
}

variable "fifo_topic" {
  description = "boolean indicating whether or not to create a FIFO (first-in-first-out) topic"
  default     = false
}

variable "sns_lambda_success_feedback_sample_rate" {
  description = "the percentage of successful messages for which you want to receive CloudWatch Logs"
  default     = "10"
}

variable "enable_lambda_feedback" {
  description = "boolean toggle to enable lambda success/failure feedback"
  default     = true
}

variable "sns_cross_account_access_arn" {
  description = "ARN to allow topic subscription"
  default     = ""
}
