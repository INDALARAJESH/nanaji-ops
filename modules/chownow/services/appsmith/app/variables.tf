variable "service" {
  description = "name of app/service"
  default     = "appsmith"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "main"
}

variable "production_environment_name" {
  description = "the production environment/account for this service"
  default     = "ncp"
}

variable "ecr_acct" {
  default = "449190145484"
}

locals {
  env                = "${var.env}${var.env_inst}"
  cluster_name       = var.custom_cluster_name != "" ? var.custom_cluster_name : "${var.service}-${local.env}"
  datadog_env        = var.env == "ncp" ? "prod" : local.env
  web_container_name = "${var.web_name}-${var.service}-${local.env}"

  ecr_repo_url = "${var.ecr_acct}.dkr.ecr.us-east-1.amazonaws.com/${var.service}"
}

variable "file_system_id" {
  description = "efs file_system_id"
  default     = ""
}

variable "root_directory" {
  description = "efs root directory"
  default     = "/"
}
