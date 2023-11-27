variable "service" {
  description = "name of app/service"
  default     = "errbot"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "image_version" {
  description = "errbot container image version"
}

variable "enable_execute_command" {
  description = "enables/disables ability to exec into container"
  default     = false
}

locals {
  env = "${var.env}${var.env_inst}"

}
