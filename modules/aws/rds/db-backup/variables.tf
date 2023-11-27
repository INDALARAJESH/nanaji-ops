variable "service" {
  description = "unique service name for project/application"
  default     = "db-backup"
}

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

variable "databases" {
  description = "list of database ARNs and retention"
}

locals {
  env  = "${var.env}${var.env_inst}"
  name = "${var.service}-${replace(data.aws_region.current.name, "-", "")}-${local.env}"

  common_tags = {
    "Environment" = local.env
    "Service"     = var.service
    "ManagedBy"   = var.tag_managed_by
  }
}
