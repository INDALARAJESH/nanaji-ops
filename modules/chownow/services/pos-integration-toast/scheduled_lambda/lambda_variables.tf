variable "lambda_name" {
  description = "Lambda name"
}

variable "lambda_image_tag" {
  description = "Handler lambda image tag."
}

variable "lambda_base_policy_arn" {
  description = "Base AWS IAM policy arn for all service lambdas"
}

variable "lambda_timeout" {
  description = "amount of time lambda function has to run in seconds"
  default     = 300
}

variable "lambda_memory_size" {
  description = "amount of memory in MB for lambda function"
  default     = 256
}

variable "image_repository_url" {
  description = "Image repository url"
}

variable "environment_variables" {
  description = "map of environment variables for the lambda function"
  type        = map(string)
  default     = {}
}

variable "cloudwatch_logs_retention" {
  description = "CloudWatch logs retention in days"
  default     = 14
}
