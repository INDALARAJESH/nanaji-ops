variable "aws_region" {
  description = "region for deploy"
  default     = ""
}

variable "aws_account_id" {
  description = "account id for deploy"
  default     = ""
}

variable "mul_2fa_table_name" {
  description = "table name"
  default     = "mulholland-2fa"
}

variable "service" {
  description = "unique service name"
  default     = "mulholland"
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

variable "mul_2fa_api_gateway_name" {
  description = "Name of Mulholland 2FA api gateway deployment"
  default     = "mulholland-2fa"
}

variable "mul_2fa_email" {
  default = ""
}

locals {
  env = var.env

  common_tags = {
    Environment         = var.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }

  extra_tags = {
    TFModule = "modules/chownow/services/mulholland/app"
  }
}
