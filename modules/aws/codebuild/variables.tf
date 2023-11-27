variable "service" {
  description = "CodeBuild project Name"
}

variable "env" {
  description = "Environement"
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

variable "custom_name" {
  description = "change codebuild project name"
  default     = ""
}

locals {
  env  = "${var.env}${var.env_inst}"
  name = var.custom_name != "" ? var.custom_name : "${var.service}-codebuild-${local.env}"

  common_tags = { "Environment" = var.env
    "Service" = var.service
  "ManagedBy" = var.tag_managed_by }
}
