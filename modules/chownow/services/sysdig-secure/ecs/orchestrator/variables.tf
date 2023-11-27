### GENERAL VARIABLES ###
variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "vpc_name" {
  description = "name of vpc"
  default     = ""
}

variable "service" {
  description = "name of service"
  default     = "sysdig-secure"
}

variable "tag_managed_by" {
  description = "what created this resource, to keep track of non-IaC modifications"
  default     = "Terraform"
}

### LOGS VARIABLES ###
variable "log_retention_days" {
  description = "Log retention in days"
  default     = "90"
}


locals {
  aws_account_id                = data.aws_caller_identity.current.account_id
  region                        = data.aws_region.current.name
  env                           = "${var.env}${var.env_inst}"
  log_group_name                = "${local.ecs_service_name}-log-group-${local.env}"
  vpc_id                        = data.aws_vpc.orchestrator_vpc.id
  subnets                       = data.aws_subnets.private_vpc_subnets.ids
  sysdig_access_key_secret_name = "${local.env}/${var.service}/sysdig_access_key"
  sysdig_access_key_secret_arn  = data.aws_secretsmanager_secret.sysdig_access_key.arn

  common_tags = merge(
    {
      Environment = local.env
      ManagedBy   = var.tag_managed_by
      Name        = local.ecs_service_name
      Service     = var.service
      VPC         = var.vpc_name
    },
    var.env_inst != "" ? { "EnvironmentInstance" = var.env_inst } : { "EnvironmentInstance" = null }
  )
}
