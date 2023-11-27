variable "lambda_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.9"
}

variable "lambda_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "lambda_memory_size" {
  description = "lambda memory allocation"
  default     = 256
}

# Set app handler in `DD_LAMBDA_HANDLER` env var.
# https://docs.datadoghq.com/serverless/installation/python/?tab=containerimage#configure-the-function
variable "lambda_handler" {
  description = "entry point of the lambda"
  default     = "datadog_lambda.handler.handler"
}

variable "user_privacy_lambda_image_uri" {
  description = ""
}

variable "vpc_private_subnet_tag_key" {
  description = "Value to filter subnets for NetworkZone tag"
  default     = "private_base"
}
