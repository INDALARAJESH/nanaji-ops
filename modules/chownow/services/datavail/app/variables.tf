variable "service" {
  description = "unique service name for project/application"
  default     = "datavail"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name to use for dns"
  default     = "chownow.com"
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
  env            = "${var.env}${var.env_inst}"
  ingress_vpn_sg = var.custom_ingress_vpc_sg != "" ? var.custom_ingress_vpc_sg : "vpn-${local.env}"
  name           = "${var.service}-bastion"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }
}
