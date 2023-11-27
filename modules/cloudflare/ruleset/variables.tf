variable "service" {
  description = "name of app/service"
  default     = "cloudflare"
}

variable "env" {
  description = "unique environment/stage name a"
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

variable "service_family" {
  description = "name of app/servicefamily"
  default     = "Cloudflare"
}

variable "tag_tfmodule" {
  description = "folder path for module location"
  default     = "modules/cloudflare/ruleset"
}

locals {
  env = format("%s%s", var.env, var.env_inst)
  common_tags = {
    Environment   = local.env
    Service       = var.service
    ServiceFamily = var.service_family
    TFModule      = var.tag_tfmodule
    ManagedBy     = var.tag_managed_by

  }
}
