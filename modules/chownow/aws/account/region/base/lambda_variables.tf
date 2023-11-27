variable "enable_lambda" {
  default = 1
}

variable "service_user" {
  default = ""
}

locals {
  // By default we share the service user between env instances (QA0x)
  service_user = var.service_user == "" ? "svc_jenkins-${var.env}" : var.service_user
}
