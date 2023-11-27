variable "service" {
  description = "name of app/service"
  default     = "qa-automation"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

locals {
  env                  = "${var.env}${var.env_inst}"
  qa_automation_bucket = "cn-${var.service}-${local.env}"
}
