variable "service" {
  description = "unique service name"
  default     = "revenue-io"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "tag_owner" {
  description = "The team which owns these resources"
  default     = "DataEng"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}


locals {
  env               = "${var.env}${var.env_inst}"
  bucket_revenue_io = "cn-${var.service}-${local.env}"
  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
  }
}
