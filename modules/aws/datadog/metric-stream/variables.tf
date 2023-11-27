variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
  default     = "datadog"
}

variable "service_family" {
  description = "unique service family for project/application"
  default     = "SharedInfrastructure"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

locals {
  env  = "${var.env}${var.env_inst}"
  name = "${var.service}-firehose-${local.env}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
    ServiceFamily       = var.service_family
  }

}
