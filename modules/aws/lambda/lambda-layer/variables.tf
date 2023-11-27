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

data "aws_region" "current" {}

locals {
  env = "${var.env}${var.env_inst}"

  common_tags = { "Environment" = "${local.env}"
  "ManagedBy" = "${var.tag_managed_by}" }
}
