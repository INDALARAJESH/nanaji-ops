variable "service" {
  description = "Service name"
}

variable "env" {
  description = "Env name"
}

variable "api_lambda_name" {
  description = "API lambda name"
}

variable "api_lambda_image_tag" {
  description = "Handler lambda image tag."
}

variable "lambda_base_policy_arn" {
  description = "Base AWS IAM policy arn for all service lambdas"
}

variable "lambda_timeout" {
  description = "amount of time lambda function has to run in seconds"
  default     = 30
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

variable "api_gw_execution_arn" {
  description = "The execution ARN of the api gateway required to add a permission to invoke the api lambda"
  type        = string
}

variable "resource_path" {
  description = "The resource path used in API GW for the lambda (ex: POST/v1/restaurants, GET/v1/restaurants/{restaurant_id}"
  type        = string
}

variable "enable_lambda_autoscaling" {
  description = "Whether to enable Application AutoScaling - operates on Provisioned concurrency"
  type        = bool
  default     = false
}

variable "lambda_provisioned_concurrency" {
  description = "Manages a Lambda Provisioned Concurrency Configuration"
  type        = number
  default     = 1
}

variable "lambda_autoscaling_min_capacity" {
  description = "The min capacity of the scalable target"
  type        = number
  default     = 1
}

variable "lambda_autoscaling_max_capacity" {
  description = "The max capacity of the scalable target"
  type        = number
  default     = 5
}

variable "lambda_provisioned_concurrency_autoscaling_target" {
  description = "Target utilization of provisioned concurrency in which to trigger autoscaling. For example 0.55 means to scale when 55% of provisioned concurrency is utilized"
  type        = number
  default     = 0.55
}
