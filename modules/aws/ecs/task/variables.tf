variable "service" {
  description = "unique service name for project/application"
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

locals {
  env     = "${var.env}${var.env_inst}"
  service = var.service_role == "" ? var.service : "${var.service}-${var.service_role}"

  common_tags = { "Environment" = local.env
    "Service" = local.service
  "ManagedBy" = var.tag_managed_by }
}
