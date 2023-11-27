variable "service" {
  description = "unique service name for project/application"
  default     = "restaurant"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

locals {
  env = "${var.env}${var.env_inst}"
}
