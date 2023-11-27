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
  env      = "${var.env}${var.env_inst}"
  username = "${var.first_name}.${var.last_name}"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    ManagedBy           = var.tag_managed_by
  }
}
