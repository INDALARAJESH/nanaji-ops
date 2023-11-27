variable "lambda_name" {
  description = "lambda function name associated with service"
  default     = "hermosa_lambda"
}

variable "lambda_low_priority_name" {
  description = "lambda function name associated with service"
  default     = "hermosa_low_priority_lambda"
}

variable "lambda_image_version" {
  description = "lambda ECR image version"
  default     = "main"
}

variable "lambda_memory_size" {
  description = "lambda memory allocation"
  default     = 1024
}

variable "lambda_timeout" {
  description = "lambda timeout seconds"
  default     = 360
}

variable "lambda_low_priority_timeout" {
  description = "lambda timeout seconds"
  default     = 900
}

variable "vpc_name_prefix" {
  description = "vpc name prefix"
}

variable "lambda_image_config_cmd" {
  description = "docker CMD for the lambda"
  default     = []
}

variable "lambda_image_config_entry_point" {
  description = "docker entry point for the lambda"
  default     = []
}

variable "dd_lambda_handler" {
  description = "handler to invoke from datadog (set as DD_LAMBDA_HANDLER environment variable)"
  default     = "event_handlers.sqs_lambda.handler"
}

variable "lambda_mapping_batch_size" {
  description = "max number of messages to send per invocation"
  default     = 5
}

variable "lambda_low_priority_mapping_batch_size" {
  description = "max number of messages to send per invocation"
  default     = 1
}

variable "lambda_maximum_batching_window_in_seconds" {
  description = "max number of seconds to assemble batch"
  default     = 5
}

variable "lambda_low_priority_maximum_batching_window_in_seconds" {
  description = "max number of seconds to assemble batch"
  default     = 1
}

variable "lambda_reserved_concurrent_executions" {
  description = "max number of lambda concurrent executions"
  default     = 500
}
