variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "api_id" {
  description = "ID of REST API gateway"
}

variable "access_log_settings" {
  description = "Cloudwatch access log settings"
  type        = list(object({ destination_arn = string, format = string }))
  # default     = []
}

variable "create_api_key" {
  description = "provides an API Gateway API Key"
  type        = bool
}

variable "redeployment_trigger" {
  description = "value"
  type        = list(any)
  default     = []
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
  env = format("%s%s", var.env, var.env_inst)

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }

}
