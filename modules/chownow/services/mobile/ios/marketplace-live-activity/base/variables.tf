variable "env" {
  description = "Environment"
}

variable "env_inst" {
  description = "Environment Instance"
  default     = ""
}

variable "service" {
  description = "The name of the service"
  default     = "marketplace-live-activity"
}

locals {
  env = "${var.env}${var.env_inst}"
}
