variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to qa01"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "service" {
  description = "name of app/service"
  default     = "integrations"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

locals {
  env = "${var.env}${var.env_inst}"

  common_tags = map(
    "Environment", local.env,
    "Service", var.service,
    "ManagedBy", var.tag_managed_by,
  )
}
