variable "service" {
  description = "unique service name"
  default     = "hermosa"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "name" {
  description = "Base name for resources"
  default     = "hermosa-aurora"
}

variable "custom_name" {
  description = "custom name"
  default     = ""
}

variable "custom_vpc_name" {
  description = "vpc override for resource placement"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_security_groups" {
  description = "Extra security groups"
  default     = []
}

variable "menu_s3_bucket_name" {
  description = "A bucket created by Menu service that Hermosa RDS needs to interact with"
  default     = "menu-rds-data-migration-TBD"
}

variable "use_internal_sg" {
  description = "add internal security group to db security groups."
  default     = 1
}

variable "custom_cluster_identifier" {
  description = "custom cluster identifier"
  default     = ""
}

variable "vpc_subnet_tag_value" {
  description = "custom subnet NetworkZone tag value to look up the subnets"
  default     = "private_base"
}

locals {
  env = "${var.env}${var.env_inst}"

  rds_s3_role_name             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/hermosa-rds-s3-role-${local.env}"
  secret_name                  = "${local.env}/${var.service}/db_master_password"
  cluster_parameter_group_name = "${var.name}-cluster-${local.env}-mysql57"
  db_parameter_group           = "${var.name}-db-${local.env}-mysql57"
  iam_policy_name              = "${var.service}-rds-s3-policy-${local.env}"
  iam_role_name                = "${var.service}-rds-s3-role-${local.env}"
  db_security_groups           = var.use_internal_sg == 0 ? var.extra_security_groups : concat(var.extra_security_groups, [data.aws_security_group.internal_allow.id])
  dns_zone_name                = "${local.env}.aws.chownow.com"

  # Conditionally adding env_inst tag, otherwise it turns into a constant diff
  env_inst_tag = var.env_inst == "" ? {} : { "EnvironmentInstance" = var.env_inst }
  common_tags = merge({
    Environment = local.env
    ManagedBy   = var.tag_managed_by
    Service     = var.service
    TFModule    = "modules/chownow/services/hermosa/db"
  }, local.env_inst_tag)
}
