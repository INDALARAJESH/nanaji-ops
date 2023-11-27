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

variable "dns_validation_zone_name" {
  description = "optional dns zone to use for validation, default to dns_zone_name"
}

locals {
  env = "${var.env}${var.env_inst}"

  dns_validation_zone_name = var.dns_validation_zone_name != "" ? var.dns_validation_zone_name : var.dns_zone_name

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }

}
