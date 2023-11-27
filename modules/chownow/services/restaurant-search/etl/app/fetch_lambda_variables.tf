variable "etl_fetch_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.9"
}

variable "etl_fetch_name" {
  description = "lambda name"
  default     = "restaurant-search-etl-fetch"
}

variable "etl_fetch_image_uri" {
  description = "lambda ECR image URI"
}

variable "etl_fetch_s3" {
  description = "boolean for enabling s3 artifacts for lambda"
  default     = false
}

variable "etl_fetch_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "etl_fetch_memory_size" {
  description = "lambda memory allocation"
  default     = 256
}

variable "etl_fetch_cron" {
  description = "boolean for enabling lambda cron"
  default     = false
}

variable "etl_fetch_lambda_handler" {
  description = "entry point of the lambda"
  default     = "lambdas.handler.handler"
}

locals {
  etl_fetch_lambda_env_vars = {
    REPLICA_DB_USER_SECRET_ID  = data.aws_secretsmanager_secret_version.replica_db_user.secret_id
    REPLICA_DB_PASS_SECRET_ID  = data.aws_secretsmanager_secret_version.replica_db_password.secret_id
    REPLICA_DB_HOSTNAME        = data.aws_db_instance.replica_db.address
    REPLICA_DB_NAME            = var.replica_db_name
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
