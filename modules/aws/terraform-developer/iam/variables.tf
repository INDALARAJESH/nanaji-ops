variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment intance number"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "service" {
  description = "unique service name for project/application"
  default     = "terraform-developer"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

locals {
  env  = "${var.env}${var.env_inst}"
  name = "${var.service}-${local.env}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }
}
