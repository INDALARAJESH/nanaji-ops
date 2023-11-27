variable "service" {
  description = "name of app/service"
  default     = "bastion"
}

variable "dns_name_suffix" {
  description = "suffix to add on to the name"
  default     = ""
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix"
}

variable "subnet_network_types" {
  description = "Subnet filter value list to pass to tag:NetworkType"
  default     = ["public"]
}

locals {
  env        = "${var.env}${var.env_inst}"
  custom_env = local.env == "ops-rp" ? "ops" : local.env
}
