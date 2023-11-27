variable "service" {
  description = "unique service name"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance number"
  default     = ""
}

variable "vpc_name" {
  description = "name of vpc for resource placement"
}

locals {
  env  = "${var.env}${var.env_inst}"
  name = "${var.service}-${local.env}"
}
