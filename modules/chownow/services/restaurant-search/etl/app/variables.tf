variable "service" {
  description = "unique service name"
  default     = "restaurant-search-etl"
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_name" {
  description = "image tag for lambda function images (i.e. git SHA)"
  default     = ""
}

variable "tag_managed_by" {
  description = "What created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "sns_topic_base_name" {
  description = "base name of sns topic -- the part of the name that doesn't include the env"
  default     = "cn-restaurant-events"
}

variable "restaurant_updated_message_type_filter" {
  description = "The value of the message attribute `type` that should be filtered on"
  default     = "com.chownow.restaurant.updated"
}

variable "sentry_dsn" {
  description = "Sentry.io API key"
  default     = "https://55ea1d34f16748dda3331c400c603234@o32006.ingest.sentry.io/6237961"
}

variable "dev_workspace" {
  description = "Name of developer specific workspace if needed"
  default     = ""
}

variable "vpc_name" {
  description = "Name of the VPC the lambdas should be in"
}

variable "replica_db_instance_id" {
  description = "Name of the replica db RDS instance"
  default     = ""
}

variable "replica_db_name" {
  description = "name of the replica db to use in the lambda function"
  default     = null
}

variable "state_machine_wait_seconds" {
  description = "Seconds to delay the state machine by"
  default     = 5
}

variable "state_machine_retry_interval_seconds" {
  description = "Seconds before the first retry attempt"
  default     = 3
}

variable "state_machine_retry_max_attempts" {
  description = "Maximum number of retry attempts"
  default     = 3
}

variable "state_machine_retry_backoff_rate" {
  description = "Multiplier to increase the retry interval by after each retry attempt"
  default     = 2
}

variable "es_domain_name_suffix" {
  description = "Suffix for the OpenSearch domain name (i.e. uat00)"
  default     = ""
}

locals {
  aws_region                          = data.aws_region.current.name
  aws_account_id                      = data.aws_caller_identity.current.account_id
  env                                 = var.dev_workspace == "" ? "${var.env}${var.env_inst}" : var.dev_workspace
  replica_db_instance_id              = var.replica_db_instance_id != "" ? var.replica_db_instance_id : "restaurant-search-dm-mysql-${local.env}"
  es_domain_name_suffix               = var.es_domain_name_suffix != "" ? var.es_domain_name_suffix : local.env
  es_host                             = "https://${data.aws_elasticsearch_domain.restaurant_search.endpoint}"
  es_access_key_id_arn                = data.aws_secretsmanager_secret_version.es_access_key_id.arn
  es_secret_access_key_arn            = data.aws_secretsmanager_secret_version.es_secret_access_key.arn
  dd_api_key_arn                      = data.aws_secretsmanager_secret_version.dd_api_key.arn
  s3_restaurant_media_bucket_hostname = local.env == "ncp" ? "menuimages.chownowcdn.com" : "menuimages.${local.env}.chownowcdn.com"

  common_tags = {
    Environment         = var.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }

  extra_tags = {
    TFModule  = "modules/chownow/services/restaurant-search/etl/app"
    workspace = local.env
  }
}
