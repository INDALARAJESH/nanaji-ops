variable "service" {
  description = "unique service name for project/application"
  default     = "terraform"
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

variable "custom_username_production" {
  description = "optional custom username for production terraform provisioning IAM user"
  default     = ""
}

variable "custom_path" {
  description = "optional custom user path"
  default     = ""
}

locals {
  env                 = "${var.env}${var.env_inst}"
  path                = var.custom_path != "" ? var.custom_path : "/${local.env}/${var.service}/users/"
  username_production = var.custom_username_production != "" ? var.custom_username_production : "svc_terraform-production"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
  }
}
