variable "service" {
  description = "unique service name for project/application"
  default     = "hermosa-order-messages"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

locals {
  env = "${var.env}${var.env_inst}"
}
