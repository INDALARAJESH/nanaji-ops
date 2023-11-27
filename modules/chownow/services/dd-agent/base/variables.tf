variable "service" {
  description = "unique service name"
  default     = "dd-agent"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance number"
  default     = ""
}

variable "vpc_names" {
  description = "list of VPCs for config secret creation"
}

locals {
  env  = "${var.env}${var.env_inst}"
  name = "${var.service}-${local.env}"

  # Creates secret to house the dd agent config for each VPC
  config_secret_list = [for s in var.vpc_names : "config-${s}"]
  secret_list        = concat(["dd_api_key"], local.config_secret_list)
}
