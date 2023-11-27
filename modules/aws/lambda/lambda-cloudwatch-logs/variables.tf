variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch Log Group name"
}

variable "cloudwatch_log_subscription_filter_pattern" {
  description = "CloudWatch Logs filter pattern for triggering a lambda fn"
  default     = ""
}

variable "lambda_name" {
  description = "unique name for lambda"
}
