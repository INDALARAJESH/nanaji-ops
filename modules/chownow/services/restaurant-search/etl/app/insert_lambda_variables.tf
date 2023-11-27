variable "etl_insert_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.9"
}

variable "etl_insert_name" {
  description = "lambda name"
  default     = "restaurant-search-etl-insert"
}

variable "etl_insert_image_uri" {
  description = "lambda ECR image URI"
}

variable "etl_insert_s3" {
  description = "boolean for enabling s3 artifacts for lambda"
  default     = false
}

variable "etl_insert_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "etl_insert_memory_size" {
  description = "lambda memory allocation"
  default     = 512
}

variable "etl_insert_cron" {
  description = "boolean for enabling lambda cron"
  default     = false
}

variable "etl_insert_lambda_handler" {
  description = "entry point of the lambda"
  default     = "lambdas.handler.handler"
}

locals {
  etl_insert_lambda_env_vars = {
    ES_AWS_ACCESS_KEY_ID_SECRET_ID     = local.es_access_key_id_arn
    ES_AWS_SECRET_ACCESS_KEY_SECRET_ID = local.es_secret_access_key_arn
    MAMMOTH_ES_HOSTS                   = local.es_host
    REPLICA_DB_USER_SECRET_ID          = data.aws_secretsmanager_secret_version.replica_db_user.secret_id
    REPLICA_DB_PASS_SECRET_ID          = data.aws_secretsmanager_secret_version.replica_db_password.secret_id
    REPLICA_DB_HOSTNAME                = data.aws_db_instance.replica_db.address
    REPLICA_DB_NAME                    = var.replica_db_name
    S3_RESTAURANT_MEDIA_BUCKET         = local.s3_restaurant_media_bucket_hostname
    DD_FLUSH_TO_LOG                    = "true"
    DD_LAMBDA_HANDLER                  = "lambdas/handler.handler"
    DD_SERVERLESS_LOGS_ENABLED         = "false"
    DD_TRACE_ENABLED                   = "true"
    DD_API_KEY_SECRET_ARN              = local.dd_api_key_arn
    DD_SERVICE                         = var.service
    DD_ENV                             = local.env
    SENTRY_DSN                         = var.sentry_dsn
    SENTRY_ENVIRONMENT                 = local.env
    SENTRY_RELEASE                     = "${var.service}@${var.tag_name}"
  }
}
