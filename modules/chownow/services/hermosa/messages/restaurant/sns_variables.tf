variable "sns_lambda_success_feedback_sample_rate" {
  description = "SNS lambda success feedback sample rate"
  default     = 100
}

variable "sns_cross_account_access_arn" {
  description = "ARN to allow topic subscription"
  default     = ""
}

locals {
  sns_topic_name = "cn-restaurant-favorite-events-${local.env}"
}
