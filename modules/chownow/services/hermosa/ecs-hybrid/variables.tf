variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "cluster_name_prefix" {
  description = "cluster name prefix"
}

variable "alb_name_prefix" {
  description = "prefix of load balancer, eg: on-demand-pub"
}

variable "custom_cluster_name" {
  description = "specify cluster name"
  default     = ""
}

variable "custom_alb_name" {
  description = "specify load balancer name"
  default     = ""
}

variable "alb_hostnames" {
  description = "list of records to allow for the alb"
  type        = list(string)
}

variable "service" {
  description = "name of app/service"
  default     = "hermosa"
}

locals {
  env          = "${var.env}${var.env_inst}"
  cluster_name = var.custom_cluster_name != "" ? var.custom_cluster_name : "${var.cluster_name_prefix}-${local.env}"
  alb_name     = var.custom_alb_name != "" ? var.custom_alb_name : "${var.alb_name_prefix}-${local.env}"
}
