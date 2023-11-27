variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
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

variable "name" {
  description = "name of log group"
}

variable "path" {
  description = "log group path"
}

variable "kms_key_id" {
  description = "Optional key to encrypts logs"
  default     = null
}

variable "retention_in_days" {
  description = "days to retain log events. 0 means forever."
  default     = 365
}

locals {
  env  = "${var.env}${var.env_inst}"
  name = "${var.path}/${var.name}"
  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }
}
