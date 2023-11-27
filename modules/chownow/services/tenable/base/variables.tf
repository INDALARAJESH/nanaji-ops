variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to qa01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "tenable"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "tag_owner" {
  description = "The team which owns these resources"
  default     = "Devops"
}

locals {
  env     = "${var.env}${var.env_inst}"
  service = var.service

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
  }
}
