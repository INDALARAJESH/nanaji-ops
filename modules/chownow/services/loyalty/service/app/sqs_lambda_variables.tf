variable "sqs_lambda_name" {
  description = "SQS lambda function name associated with service"
  default     = "loyalty-sqs-lambda"
}

variable "sqs_lambda_memory_size" {
  description = "lambda memory allocation"
  default     = 848
}

variable "sqs_lambda_timeout" {
  description = "lambda timeout seconds"
  default     = 900
}

variable "sqs_lambda_image_config_cmd" {
  description = "docker CMD for the lambda"
  default     = ["python", "-m", "awslambdaric", "datadog_lambda.handler.handler"]

}

variable "sqs_dd_lambda_handler" {
  description = "handler to invoke from datadog (set as DD_LAMBDA_HANDLER environment variable)"
  default     = "event_handlers.sqs_dynamo.handle"
}

variable "sqs_lambda_mapping_batch_size" {
  description = "max number of messages to send per invocation"
  default     = 10
}

variable "sqs_refresh_schedule_expression" {
  description = "schedule to run the sqs lambda (refresh)"
  default     = "cron(0 16 ? * SUN *)"
}

variable "sqs_refresh_cron_boolean" {
  description = "enable/disable the lambda cron schedule"
  default     = "true"
}
