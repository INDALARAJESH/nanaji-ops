variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "integrations"
}

variable "service_id" {
  description = "unique service identifier, eg '-in' => integrations-in"
  default     = ""
}

variable "domain_public" {
  description = "public domain name information"
  default     = "svpn.chownow.com"
}

variable "deployment_suffix" {
  description = "suffix used to name service and lookup of the name of target group to attach to"
  default     = ""
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to launch databases in"
  default     = "nc"
}

locals {
  alb_log_bucket = "${var.service}-alb-${local.env}-logs"
  aws_account_id = data.aws_caller_identity.current.account_id

  env                  = "${var.env}${var.env_inst}"
  datadog_env          = var.env == "ncp" ? "prod" : local.env
  logs_lambda_name     = "cloudwatch2loggly_lambda_${local.env}_${replace(local.region, "-", "")}_chownow_com"
  logs_lambda_iam_role = "cloudwatch2loggly_lambda_${local.env}_${replace(local.region, "-", "")}_chownow_com"
  region               = data.aws_region.current.name
  service              = "${var.service}${var.service_id}"
  full_service         = var.deployment_suffix != "" ? "${local.service}-${var.deployment_suffix}" : local.service
}
