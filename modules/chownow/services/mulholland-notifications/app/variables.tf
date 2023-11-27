variable "aws_region" {
  description = "region for deploy"
  default     = ""
}

variable "aws_account_id" {
  description = "account id for deploy"
}

variable "service" {
  description = "unique service name"
  default     = "mulholland-notifications"
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "What created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "slack_target" {
  description = "target name for slack notifications"
  default     = "slack"
}

locals {
  env = "${var.env}${var.env_inst}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }

  extra_tags = {
    TFModule = "modules/chownow/services/mulholland-notifications/app"
  }
}
