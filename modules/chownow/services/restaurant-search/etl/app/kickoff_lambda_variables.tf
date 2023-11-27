variable "etl_kickoff_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.9"
}

variable "etl_kickoff_name" {
  description = "lambda name"
  default     = "restaurant-search-etl-kickoff"
}

variable "etl_kickoff_image_uri" {
  description = "lambda ECR image URI"
}

variable "etl_kickoff_s3" {
  description = "boolean for enabling s3 artifacts for lambda"
  default     = false
}

variable "etl_kickoff_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "etl_kickoff_memory_size" {
  description = "lambda memory allocation"
  default     = 128
}

variable "etl_kickoff_cron" {
  description = "boolean for enabling lambda cron"
  default     = false
}

variable "etl_kickoff_lambda_handler" {
  description = "entry point of the lambda"
  default     = "lambdas.handler.handler"
}

locals {
  etl_kickoff_lambda_env_vars = {
    ETL_STATE_MACHINE_ARN      = aws_sfn_state_machine.restaurant_search_etl_state_machine.id
    KICKOFF_DLQ_URL            = module.restaurant_search_etl_kickoff_dlq.sqs_queue_url
    DD_FLUSH_TO_LOG            = "true"
    DD_LAMBDA_HANDLER          = "lambdas/handler.handler"
    DD_SERVERLESS_LOGS_ENABLED = "false"
    DD_TRACE_ENABLED           = "true"
    DD_API_KEY_SECRET_ARN      = local.dd_api_key_arn
    DD_SERVICE                 = var.service
    DD_ENV                     = local.env
    SENTRY_DSN                 = var.sentry_dsn
    SENTRY_ENVIRONMENT         = local.env
    SENTRY_RELEASE             = "${var.service}@${var.tag_name}"
  }
}
