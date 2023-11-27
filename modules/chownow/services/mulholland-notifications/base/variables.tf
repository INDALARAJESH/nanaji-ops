variable "service" {
  description = "name of app/service"
  default     = "mulholland-notifications"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "What created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

locals {
  env = var.env

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }

  extra_tags = {
    TFModule = "modules/chownow/services/mulholland-notifications/base"
  }
}
