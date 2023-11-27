variable "service" {
  description = "name of app/service"
  default     = "appbuilder"
}

variable "custom_name" {
  description = "name of bucket and user"
  default     = "appbuilder"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

locals {
  env = "${var.env}${var.env_inst}"
}
