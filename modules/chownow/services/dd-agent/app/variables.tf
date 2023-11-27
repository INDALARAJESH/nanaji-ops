variable "service" {
  description = "unique service name"
  default     = "dd-agent"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance number"
  default     = ""
}

variable "vpc_name" {
  description = "name of vpc for resource placement"
}

locals {
  env          = "${var.env}${var.env_inst}"
  name         = "${var.service}-${var.vpc_name}"
  cluster_name = "${var.service}-${var.env}"

  # Secret Variables
  config_secret          = "${var.env}/${var.service}/config-${var.vpc_name}"
  config_secret_arn      = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.config_secret}"
  dd_api_key_secret_name = "${var.env}/${var.service}/dd_api_key"
  dd_api_key_arn         = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.dd_api_key_secret_name}"

  # Handling use of legacy "internal" security group
  enable_internal_allow = var.vpc_name == local.env ? 1 : 0
  internal_allow_sg     = local.enable_internal_allow == 1 ? [data.aws_security_group.internal_allow[0].id] : []

  env_inst_tag = var.env_inst == "" ? {} : map("EnvironmentInstance", var.env_inst, )
  common_tags = merge({
    Environment = local.env
    ManagedBy   = "Terraform"
    Service     = var.service
  }, local.env_inst_tag)
}
