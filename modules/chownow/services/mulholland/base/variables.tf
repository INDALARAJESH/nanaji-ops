variable "service" {
  description = "name of app/service"
  default     = "mulholland"
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
  extra_tags = {
    TFModule = "modules/chownow/services/mulholland/base"
  }
}
