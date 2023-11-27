variable "handler_name" {
  description = "Handler name"
}

variable "handler_lambda_image_tag" {
  description = "Handler lambda image tag."
}

variable "mapping_batch_size" {
  description = "SQS mapping batch size"
  default     = 10
}

variable "lambda_base_policy_arn" {
  description = "Base AWS IAM policy arn for all service lambdas"
}

variable "lambda_timeout" {
  description = "amount of time lambda function has to run in seconds"
  default     = 10
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

# vpc configuration (optional)
variable "lambda_vpc_subnet_ids" {
  description = "VPC subnet ids where the lambda function can be executed"
  type        = list(string)
  default     = []
}

variable "lambda_security_group_ids" {
  description = "Security group ids for the lambda function"
  default     = []
}
