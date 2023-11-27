variable "service" {
  description = "name of app/service"
  default     = "sherlock"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "main"
}

variable "app_dashboard_url" {
  description = "app-dashboard url"
  default     = ""
}

locals {
  env                  = "${var.env}${var.env_inst}"
  container_name       = "${var.service}-${local.env}"
  dns_zone             = "${local.env == "prod" ? "${var.domain}" : "${local.env}.svpn.${var.domain}"}"
  aws_account_id       = "${data.aws_caller_identity.current.account_id}"
  region               = "${data.aws_region.current.name}"
  logs_lambda_name     = "cloudwatch2loggly_lambda_${var.env}_${replace(data.aws_region.current.name, "-", "")}_chownow_com"
  logs_lambda_iam_role = "cloudwatch2loggly_lambda_${var.env}_${replace(data.aws_region.current.name, "-", "")}_chownow_com"
}
