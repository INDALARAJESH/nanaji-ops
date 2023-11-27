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

variable "channels_data_s3_bucket_name" {
  description = "name of S3 bucket for Channels Data Service"
  default     = ""
}

variable "channels_data_s3_aws_account_ids" {
  description = "AWS account IDs that will have access to Channels Data S3 bucket"
  default     = []
  type        = list(string)
}


locals {
  env                           = "${var.env}${var.env_inst}"
  channels_data_s3_bucket_name  = var.channels_data_s3_bucket_name == "" ? "cn-${var.service}-${local.env}" : var.channels_data_s3_bucket_name
  channels_data_aws_account_ids = concat(list(data.aws_caller_identity.current.account_id), var.channels_data_s3_aws_account_ids)
  extra_tags = {
    TFModule = "modules/chownow/services/channels-data/base"
    Owner    = "food-network"
  }
}
