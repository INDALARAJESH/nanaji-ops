variable "service" {
  description = "name of service"
  default     = "jumpbox"
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

variable "subnet_id" {
  type        = string
  description = "[string] subnet id to provision this jumpbox in."
  default     = ""
}

variable "vpc_name" {
  description = "name of vpc for resource placement"
}

variable "additional_security_groups" {
  description = "additional security groups to attach to the instance"
  default     = []
}

variable "enable_sysdig" {
  type        = bool
  description = "Sysdig packages will be removed when set to false"
  default     = false
}

locals {
  env                             = "${var.env}${var.env_inst}"
  name                            = "jumpbox-${var.vpc_name}"
  dd_api_key_secret_name          = "${local.env}/${var.service}/dd_api_key"
  threatstack_key_secret_name     = "${local.env}/${var.service}/threatstack_key"
  teleport_selfsigned_secret_name = "${local.env}/${var.service}/teleport_selfsigned_secret"
  sysdig_access_key_secret_name   = "${local.env}/${var.service}/sysdig_access_key"

  env_inst_tag = var.env_inst == "" ? {} : map("EnvironmentInstance", var.env_inst, )
  common_tags = merge({
    Environment = local.env
    ManagedBy   = var.tag_managed_by
    Name        = local.name
    Service     = "jumpbox"
    VPC         = var.vpc_name
  }, local.env_inst_tag)
}
