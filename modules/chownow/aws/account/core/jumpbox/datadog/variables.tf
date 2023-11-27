variable "service" {
  description = "unique service name"
  default     = "jumpbox-monitor"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

locals {
  env = "${var.env}${var.env_inst}"

}
