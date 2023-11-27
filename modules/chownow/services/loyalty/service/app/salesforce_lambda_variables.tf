variable "salesforce_lambda_name" {
  description = "Salesforce lambda function name"
  default     = "loyalty-salesforce-lambda"
}

variable "salesforce_lambda_memory_size" {
  description = "lambda memory allocation"
  default     = 1024
}

variable "salesforce_lambda_timeout" {
  description = "lambda timeout seconds"
  default     = 300
}

variable "salesforce_lambda_image_config_cmd" {
  description = "docker CMD for the lambda"
  default     = ["python", "-m", "awslambdaric", "datadog_lambda.handler.handler"]
}

variable "salesforce_dd_lambda_handler" {
  description = "handler to invoke from datadog (set as DD_LAMBDA_HANDLER environment variable)"
  default     = "event_handlers.salesforce_ddb.handle"
}

variable "salesforce_cloudwatch_schedule_expression" {
  description = "schedule to run the salesforce lambda"
  default     = "cron(15 * * * ? *)"
}

variable "salesforce_lambda_cron_boolean" {
  description = "enable/disable the lambda cron schedule"
  default     = "true"
}
