variable "service" {
  description = "unique service name for project/application"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "custom_name" {
  description = "Name override for resource placement"
  default     = ""
}

variable "custom_vpc_name" {
  description = "vpc override for resource placement"
  default     = ""
}

variable "custom_cluster_identifier" {
  description = "identifier override for resource placement"
  default     = ""
}

locals {
  env                = format("%s%s", var.env, var.env_inst)
  name               = var.custom_name != "" ? var.custom_name : format("%s-aurora-postgresql-%s", var.service, local.env)
  cluster_identifier = var.custom_cluster_identifier != "" ? var.custom_cluster_identifier : format("%s-aurora-postgresql-%s", var.service, local.env)
  vpc_name           = var.custom_vpc_name != "" ? var.custom_vpc_name : format("%s-%s", var.vpc_name_prefix, local.env)


  ### db local variables
  cname_endpoint         = var.custom_cname_endpoint != "" ? var.custom_cname_endpoint : format("%s-db-%s", var.service, var.db_name_suffix)
  cname_endpoint_reader  = var.custom_cname_endpoint_reader != "" ? var.custom_cname_endpoint_reader : format("%s-db-replica", var.service)
  db_password            = var.custom_db_password != "" ? var.custom_db_password : random_password.master_password.result
  db_monitoring_role_arn = var.db_enable_monitoring == 1 ? aws_iam_role.rds_enhanced_monitoring[0].arn : ""
  db_monitoring_interval = var.db_enable_monitoring == 1 ? var.db_monitoring_interval : null

  ### Production conditionals
  dns_zone   = format("%s.aws.%s", local.env, var.domain)
  is_private = local.env == "prod" ? 0 : 1

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    VPC                 = local.vpc_name
    Service             = var.service
  }

}
