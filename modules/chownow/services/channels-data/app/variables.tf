variable "service" {
  description = "unique service name"
  default     = "channels-data"
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "lev_dd_flush_to_log" {
  description = "Lambda environment var for `datadog-lambda` DD_FLUSH_TO_LOG setting"
  default     = "true"
}

variable "lev_dd_lambda_handler" {
  description = "Lambda environment var for `datadog-lambda` specifying entrypoint handler"
  default     = "src.app.snowflake_etl_handler"
}

variable "lev_dd_log_level" {
  description = "Lambda environment var for `datadog-lambda` DD_LOG_LEVEL setting"
  default     = "info"
}

variable "lev_dd_trace_enabled" {
  description = "Lambda environment var for `datadog-lambda` DD_TRACE_ENABLED setting"
  default     = "true"
}

variable "lev_snowflake_warehouse" {
  description = "Snowflake warehouse (compute layer) to use for queries"
  default     = "channels_service_wh"
}

variable "lev_sentry_dsn" {
  description = "Sentry DSN. The DSN tells the SDK where to send the events to."
  default     = "https://e0b34cdd2e394ba58c4909d377665088@o32006.ingest.sentry.io/6058821"
}

variable "vpc_placement_subnets" {
  description = "subnets that the cds lambda function should execute from"
  type        = list(string)
}

variable "singleplatform_s3_bucket" {
  description = "SinglePlatform S3 bucket name. It is external bucket"
  default     = "cn-cds-singleplatfrom-dev"
}

variable "singleplatform_csv_filename_action_provider" {
  description = "CSV file name for SinglePlatform provider"
  default     = "chownow_action_providers"
}

locals {
  env                      = "${var.env}${var.env_inst}"
  box_ftp_folder           = local.env == "ncp" ? "ChowNow" : "ChowNow_${local.env}"
  datadog_env              = local.env == "ncp" ? "prod" : local.env
  dd_api_key_arn           = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog/ops_api_key"
  google_starter_feed_name = local.env == "ncp" ? "merchant_feed" : "${local.env}_merchant_feed"
  lambda_classification    = "${var.service}_${local.env}"
  nextdoor_s3_bucket       = "chownow-channels-nextdoor-${local.env}"

  food_network_test_email = "foodnetwork-testing@chownow.com"
  tripadvisor_email       = local.env == "ncp" ? "foodnetwork@chownow.com" : local.food_network_test_email
  opentable_email         = local.env == "ncp" ? "opentable-feed@chownow.com" : local.food_network_test_email
  default_reply_to        = local.env == "ncp" ? "ChowNow <no-reply@chownow.com>" : "CDS Testing <no-reply@chowqa.com>"

  query_limit = local.env == "ncp" || local.env == "stg" ? "" : "500"

  lambda_env_variables = {
    BOX_SECRET_NAME                             = "${local.env}/${var.service}/box_credentials"
    BOX_FTP_FOLDER                              = local.box_ftp_folder
    CHANNELS_BUCKET                             = "cn-${var.service}-${local.env}"
    CHANNELS_SENTRY_DSN                         = var.lev_sentry_dsn
    DD_API_KEY_SECRET_ARN                       = local.dd_api_key_arn
    DD_ENV                                      = local.datadog_env
    DD_FLUSH_TO_LOG                             = var.lev_dd_flush_to_log
    DD_LAMBDA_HANDLER                           = var.lev_dd_lambda_handler
    DD_LOG_LEVEL                                = var.lev_dd_log_level
    DD_SERVERLESS_LOGS_ENABLED                  = "false" # Use log forwarder in app/logs.tf instead
    DD_SERVICE                                  = var.service
    DD_TRACE_ENABLED                            = var.lev_dd_trace_enabled
    DEFAULT_REPLY_TO                            = local.default_reply_to
    DOCUMENTDB_CONNECTION_STRING                = "mongodb://{username}:{password}@{host}:{port}/?tls=true&tlsCAFile={pem_file_path}&retryWrites=false&directConnection=true"
    DOCUMENTDB_PEM_FILENAME                     = "rds-combined-ca-bundle.pem"
    DOCUMENTDB_CREDS_SECRET_NAME                = "${local.env}/${var.service}/documentdb_credentials"
    EMAIL_CREDENTIAL_SECRET_NAME                = "${local.env}/${var.service}/email_credentials"
    ENV                                         = local.env
    FOOD_NETWORK_TEST_EMAIL                     = local.food_network_test_email
    GOOGLE_STARTER_SFTP_PORT                    = 19321
    GOOGLE_STARTER_SECRET_NAME                  = "${local.env}/${var.service}/google_starter_credentials"
    GOOGLE_STARTER_SFTP_HOST                    = "partnerupload.google.com"
    GOOGLE_STARTER_SFTP_USER_MERCHANTS_DROPBOX  = var.google_starter_merchant
    GOOGLE_STARTER_FEED_NAME                    = local.google_starter_feed_name
    GOOGLE_STARTER_EMAILS                       = local.food_network_test_email
    NEXTDOOR_S3_BUCKET                          = local.nextdoor_s3_bucket
    OPENTABLE_DATAFEED_EMAILS                   = local.opentable_email
    RESTAURANT_QUERY_LIMIT                      = local.query_limit
    SERVICE                                     = var.service
    SNOWFLAKE_SECRET_NAME                       = "${local.env}/${var.service}/snowflake_credentials"
    SNOWFLAKE_WAREHOUSE                         = var.lev_snowflake_warehouse
    TRIPADVISOR_DATAFEED_EMAILS                 = local.tripadvisor_email
    SINGLEPLATFORM_S3_BUCKET                    = var.singleplatform_s3_bucket
    SINGLEPLATFORM_CSV_FILENAME_ACTION_PROVIDER = var.singleplatform_csv_filename_action_provider
    SINGLEPLATFORM_S3_SECRET_NAME               = "${local.env}/${var.service}/singleplatform_s3_credentials"
  }

  extra_tags = {
    TFModule = "modules/chownow/services/channels-data/app"
    Owner    = "food-network"
  }
}
