variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
  default     = "SERVICENAMEGOESHERE"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "main"
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

locals {
  env      = "${var.env}${var.env_inst}"
  dns_zone = local.env == "ncp" ? var.domain : "${local.env}.svpn.${var.domain}"
  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
  }
}
