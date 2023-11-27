variable "env" {
  description = "environment"
}

variable "env_inst" {
  description = "environment instance name"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "service" {
  description = "unique service name"
}

variable "domain" {
  description = "domain to use for lambda"
  default     = ""
}

locals {
  env = "${var.env}${var.env_inst}"
  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    TFModule            = "modules/aws/lambda/basic"
    Service             = var.service
  }
  datadog_tags = {
    service = var.service
    env     = local.env
  }
}
