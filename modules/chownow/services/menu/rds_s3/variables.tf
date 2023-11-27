variable "env" {
  description = "Unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "Name of app/service"
  default     = "menu"
}

variable "hermosa_account_id" {}

locals {
  env = "${var.env}${var.env_inst}"

  s3_bucket_name = "${var.service}-rds-data-migration-${local.env}"
}
