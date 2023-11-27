variable "env" {
  default = "dev"
}

variable "env_inst" {
  default = ""
}

variable "service" {
  default = "on-demand"
}

variable "vpc_name_prefix" {
  description = "Prefixed used to find the available vpc using <prefix>-<var.env> format"
  default     = ""
}

variable "security_group_name_override" {
  description = "Specific security group name used to attach security group to alb."
  default     = ""
}

locals {
  env                = "${var.env}${var.env_inst}"
  certificate_domain = "${var.env}.svpn.chownow.com"
  selected_vpc       = var.vpc_name_prefix != "" ? "${var.vpc_name_prefix}-${local.env}" : local.env
  selected_sg        = var.security_group_name_override != "" ? var.security_group_name_override : "vpn_web-${local.env}"
}
