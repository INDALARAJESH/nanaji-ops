variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  default = "sysdig-secure"
}

variable "service_family" {
  default = "Security"
}

variable "sysdig_access_key_secret_name" {
  default = "sysdig_access_key"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "enable_secret_version" {
  description = "allows to disable secret version creation"
  default     = 1
}

locals {
  env = "${var.env}${var.env_inst}"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ServiceFamily       = var.service_family,
    ManagedBy           = var.tag_managed_by
  }
}
