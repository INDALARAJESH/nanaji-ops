variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "lambda"
}

variable "service_user" {
  description = "service user used to override when sharing service user among sub environments (qa0x)"
  default = ""
}

locals {
  env         = "${var.env}${var.env_inst}"
  bucket_name = "cn-${local.env}-repo"
  service_user = var.service_user == "" ? "svc_jenkins-${local.env}" : var.service_user
  common_tags = {
    Environment         = var.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = "Terraform"
    Service             = var.service
    TFModule            = "chownow/services/lambda/deploy"
  }
}
