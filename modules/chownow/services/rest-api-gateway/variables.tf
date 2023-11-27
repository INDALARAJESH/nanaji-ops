variable "name" {
  description = "unique name"
  default     = "channels"
}

variable "domain" {
  description = "DNS domain name"
}

variable "subdomain" {
  description = "DNS subdomain name"
}

variable "env" {
  description = "unique environment name"
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
  common_tags = {
    TFModule            = "modules/chownow/services/rest-api-gateway"
    Environment         = var.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }
}
