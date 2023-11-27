variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
  default     = "data-redaction"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "image_version" {
  description = "version of service, usually as a git SHA commit"
  default     = "latest"
}

variable "app_name" {
  description = "name of application"
}

variable "target_db" {
  description = "target database name"
}

variable "image_repository_arn" {
  description = "ECR repository_arn"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com/data-redaction"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "cluster_prefix" {
  description = "allows custom cluster prefix"
  default     = ""
}

variable "db_prefix" {
  description = "allows custom db instance prefix"
  default     = ""
}

locals {
  env                                 = "${var.env}${var.env_inst}"
  ssm_prefix                          = "/${local.env}/${var.service}"
  role_name_with_path                 = "data-redaction-task-ecs-*"
  db_prefix                           = var.db_prefix == "" ? "hermosa-mysql-${local.env}" : var.db_prefix
  cluster_prefix                      = var.cluster_prefix == "" ? local.db_prefix : var.cluster_prefix
  source_db_cluster_instance_name     = local.cluster_prefix
  source_cluster_parameter_group_name = "hermosa-aurora-cluster-${local.env}-*"
  source_cluster_snapshot_name        = "${local.cluster_prefix}*"
  source_db_instance_name             = "${local.db_prefix}*"
  target_cluster_snapshot_name        = "${local.cluster_prefix}-devscrubbed-*"
  target_db_cluster_instance_name     = "${local.cluster_prefix}-devscrub-*"
  target_db_instance_name             = "${local.cluster_prefix}-devscrub-*"
  target_cluster_parameter_group_name = "hermosa-aurora-cluster-${local.env}-*-scrub-temp"
  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
  }
}
