variable "service" {
  description = "name of app/service"
  default     = "YOURSERVICENAME"
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

locals {
  env                = "${var.env}${var.env_inst}"
  cluster_name       = var.custom_cluster_name != "" ? var.custom_cluster_name : "${var.service}-${local.env}"
  datadog_env        = var.env == "ncp" ? "prod" : local.env
  web_container_name = "${var.web_name}-${var.service}-${local.env}"

  # If it's a production account use the account's ECR repo, otherwise use the dev account ECR repo
  prod_envs    = ["data", "ncp", "pde-prod", "prod"]
  ecr_repo_url = contains(local.prod_envs, local.env) ? "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.service}" : "229179723177.dkr.ecr.us-east-1.amazonaws.com/${var.service}"
}
