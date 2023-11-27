variable "service" {
  description = "unique service name"
  default     = "matillion"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "tag_owner" {
  description = "The team which owns these resources"
  default     = "DataEng"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "svpn_subdomain" {
  description = "subdomain name to use for resource creation"
  default     = "svpn"
}

variable "domain" {
  description = "domain name to use for resource creation"
  default     = "chownow.com"
}

variable "custom_vpc_name" {
  description = "overrides default vpc for resource placement"
  default     = ""
}

variable "sns_to_slack_lambda_function_name" {
  description = "name of lambda used to send messages to slack"
  default     = "sns_to_slack_lambda_data_useast1_chownow_com"
}

variable "sns_to_slack_topic_name" {
  description = "name of SNS topic to subscribe to for slack notifications"
}

locals {
  env          = "${var.env}${var.env_inst}"
  vpc_name     = var.custom_vpc_name != "" ? var.custom_vpc_name : "main-${local.env}"
  ami          = var.custom_ami != "" ? var.custom_ami : data.aws_ami.matillion.image_id
  server_group = "${var.service}-${local.env}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
    VPC                 = local.vpc_name
  }
}
