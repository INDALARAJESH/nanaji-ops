variable "create_access_key" {
  description = "boolean flag to create iam user access/secret key"
  default     = 0
}

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

variable "custom_username" {
  description = "optional custom user name"
  default     = ""
}

variable "custom_path" {
  description = "optional custom user path"
  default     = ""
}

locals {
  env      = "${var.env}${var.env_inst}"
  username = var.custom_username != "" ? var.custom_username : "${var.name_prefix}_${var.service}-${local.env}"
  path     = var.custom_path != "" ? var.custom_path : "/${local.env}/${var.service}/users/"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
  }
}
