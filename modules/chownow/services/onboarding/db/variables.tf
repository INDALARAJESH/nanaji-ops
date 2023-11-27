variable "env" {
  description = "unique environment name"
  default     = "dev"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name"
  default     = "onboarding"
}

variable "billing_mode" {
  description = "Controls billing for read/write throughput"
  default     = "PROVISIONED"
}

variable "read_capacity" {
  description = "The number of write units for this table"
  default     = "20"
}

variable "write_capacity" {
  description = "The number of read units for this table"
  default     = "20"
}

variable "hash_key" {
  description = "The name of the hash key in the index "
  default     = "uuid"
}

variable "attribute_list" {
  description = "Table attribute list"
  type        = list(object({ name = string, type = string }))
  default     = [{ name = "uuid", type = "S" }]
}

variable "global_secondary_index" {
  description = "Global secondary index attributes for this table"
  default     = []
}

variable "cors_allow_origin_url" {
  description = "allowed origin for CORS headers"
  default     = "https://dashboard.chownow.com"
}


locals {
  env                                = "${var.env}${var.env_inst}"
  lower_case_env                     = lower(local.env)
  schedule_table_name                = "${var.service}-schedule-${local.lower_case_env}"
  menu_link_table_name               = "${var.service}-menu-link-${local.lower_case_env}"
  assets_upload_url_table_name       = "${var.service}-assets-upload-url-${local.lower_case_env}"
  salesforce_client_cache_table_name = "${var.service}-salesforce-client-cache-${local.lower_case_env}"
  progress_table_name                = "${var.service}-progress-${local.lower_case_env}"
  website_access_table_name          = "${var.service}-website-access-${local.lower_case_env}"
  promotion_table_name               = "${var.service}-promotion-${local.lower_case_env}"
  onboarding_table_name              = "${var.service}-onboarding-${local.lower_case_env}"

  s3_bucket_name                  = "${var.service}-menu-files-${var.env}"
  onboarding_files_s3_bucket_name = "cn-${var.service}-files-${var.env}"
  s3_object_expiration_days       = 30

  extra_tags = {
    TFModule = "ops-tf-modules/modules/chownow/services/onboarding/db" # Required for some base modules
  }
}
