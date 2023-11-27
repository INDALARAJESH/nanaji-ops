variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
  default     = "security"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

locals {
  env                = "${var.env}${var.env_inst}"
  syslog_bucket_name = "chownow-syslog-${local.env}"

  cloudtrail_bucket_name = "${var.name_prefix}-cloudtrail-logs-${local.env}"
  cloudtrail_name        = "cloudtrail-s3-logs-${local.env}"

  common_tags = map(
    "Environment", local.env,
    "ManagedBy", var.tag_managed_by,
    "Service", var.service,
    "ServiceFamily", "Security",
  )
}
