variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "channels"
}

locals {
  env                       = "${var.env}${var.env_inst}"
  s3_object_expiration_days = 14
}
