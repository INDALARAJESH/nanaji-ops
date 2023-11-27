variable "etl_delete_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.9"
}

variable "etl_delete_name" {
  description = "lambda name"
  default     = "restaurant-search-etl-delete"
}

variable "etl_delete_image_uri" {
  description = "lambda ECR image URI"
}

variable "etl_delete_s3" {
  description = "boolean for enabling s3 artifacts for lambda"
  default     = false
}

variable "etl_delete_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "etl_delete_memory_size" {
  description = "lambda memory allocation"
  default     = 256
}

variable "etl_delete_cron" {
  description = "boolean for enabling lambda cron"
  default     = false
}

variable "etl_delete_lambda_handler" {
  description = "entry point of the lambda"
  default     = "lambdas.handler.handler"
}

locals {
  etl_delete_lambda_env_vars = {
    ES_AWS_ACCESS_KEY_ID_SECRET_ID     = local.es_access_key_id_arn
    ES_AWS_SECRET_ACCESS_KEY_SECRET_ID = local.es_secret_access_key_arn
    MAMMOTH_ES_HOSTS                   = local.es_host
    DD_FLUSH_TO_LOG                    = "true"
    DD_LAMBDA_HANDLER                  = "lambdas/handler.handler"
    DD_API_KEY_SECRET_ARN              = local.dd_api_key_arn
    DD_SERVICE                         = var.service
    DD_SERVERLESS_LOGS_ENABLED         = "false" # Use log forwarder in app/logs.tf instead
    DD_LOG_LEVEL                       = "info"
    DD_ENV                             = local.env
    SENTRY_DSN                         = var.sentry_dsn
    SENTRY_ENVIRONMENT                 = local.env
    SENTRY_RELEASE                     = "${var.service}@${var.tag_name}"
  }
}
