variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
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
  env            = "${var.env}${var.env_inst}"
  s3_bucket_name = "${var.name_prefix}-s3-access-logs-${local.env}"
  common_tags = {
    "Environment" = local.env,
    "ManagedBy"   = var.tag_managed_by,
  }
}
