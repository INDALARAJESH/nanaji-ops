variable "domain_public" {
  description = "public domain name information"
  default     = "svpn.chownow.com"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "hermosa"
}

variable "alb_name_prefix" {
  description = "prefix of load balancer, eg: on-demand-pub"
}

variable "alb_hostnames" {
  description = "list of records to allow for the alb"
  type        = list(string)
}

variable "service_id" {
  description = "unique service identifier, eg '-in' => hermosa-in"
  default     = ""
}

variable "dns_ttl" {
  description = "TTL on route53 records"
  default     = "300"
}

variable "cluster_name_prefix" {
  description = "cluster name prefix"
  default     = "on-demand"
}

variable "custom_cluster_name" {
  description = "specify cluster name"
  default     = ""
}

variable "custom_alb_name" {
  description = "specify load balancer name"
  default     = ""
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "main"
}

locals {
  aws_account_id       = data.aws_caller_identity.current.account_id
  target_group_name    = local.service
  env                  = "${var.env}${var.env_inst}"
  logs_lambda_name     = "cloudwatch2loggly_lambda_${local.env}_${replace(local.region, "-", "")}_chownow_com"
  logs_lambda_iam_role = "cloudwatch2loggly_lambda_${local.env}_${replace(local.region, "-", "")}_chownow_com"
  region               = data.aws_region.current.name
  service              = "${var.service}${var.service_id}"
  cluster_name         = var.custom_cluster_name != "" ? var.custom_cluster_name : "${var.cluster_name_prefix}-${local.env}"
  alb_name             = var.custom_alb_name != "" ? var.custom_alb_name : "${var.alb_name_prefix}-${local.env}"
  vpc_name             = var.vpc_name_prefix != "" ? "${var.vpc_name_prefix}-${local.env}" : local.env
}
