variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "dns_zone" {
  description = "DNS zone name"
  default     = "chowqa.com"
}

variable "dns_records" {
  description = "list of DNS records for zone"
}

locals {
  env = "${var.env}${var.env_inst}"

  env_inst_tag = var.env_inst == "" ? {} : map("EnvironmentInstance", var.env_inst, )
  common_tags = merge({
    Environment = local.env
    ManagedBy   = "Terraform"
  }, local.env_inst_tag)
}
