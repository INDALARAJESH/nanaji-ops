variable "api_gateway_name" {
  description = "Name of REST API gateway"
}

variable "lambda_arn" {
  description = "arn of the lambda to call"
}

variable "lambda_invoke_arn" {
  description = "invoke arn of the lambda to call"
}

variable "path_prefix" {
  description = "HTTP path prefix. ie 'fbe' "
  default     = ""
}

variable "access_log_settings" {
  description = "Cloudwatch access log settings"
  type        = list(object({ destination_arn = string, format = string }))
  default     = []
}

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

locals {
  env = "${var.env}${var.env_inst}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }

}
