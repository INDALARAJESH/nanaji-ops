variable "lambda_name" {
  description = "lambda function name associated with service"
  default     = "etl"
}

variable "lambda_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.9"
}

variable "lambda_image_uri" {
  description = "lambda ECR image URI"
  default     = ""
}

variable "lambda_s3" {
  description = "boolean for enabling s3 artifacts for lambda"
  default     = false
}

variable "lambda_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "lambda_memory_size" {
  description = "lambda memory allocation"
  default     = 1024
}

# Set app handler in `DD_LAMBDA_HANDLER` env var.
# https://docs.datadoghq.com/serverless/installation/python/?tab=containerimage#configure-the-function
variable "lambda_handler" {
  description = "entry point of the lambda"
  default     = "datadog_lambda.handler.handler"
}

variable "cloudwatch_schedule_expression" {
  description = "schedule in cron notation to run lambda"
  default     = "cron(0 10 * * ? *)"
}

variable "lambda_cron_boolean" {
  description = "boolean for enabling lambda cron"
  default     = true
}

variable "google_starter_merchant" {
  description = "Lower Env Google Starter SFTP Merchant Username"
  default     = "feeds-77n569"
}
