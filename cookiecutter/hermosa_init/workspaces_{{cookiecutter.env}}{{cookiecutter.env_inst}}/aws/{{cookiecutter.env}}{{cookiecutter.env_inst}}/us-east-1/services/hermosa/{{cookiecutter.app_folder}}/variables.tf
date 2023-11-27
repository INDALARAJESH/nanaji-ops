variable "service" {
  default = "hermosa"
}

variable "cluster_name_prefix" {
  default = "hermosa"
}

variable "wait_for_steady_state" {
  description = "wait for deployment to be ready"
  default     = true
}

variable "dd_trace_enabled" {
  default = true
}

variable "vpc_name" {
  default = "{{cookiecutter.vpc_name}}"
}

variable "deployment_suffix" {
  default = "{{cookiecutter.deployment_suffix}}"
}

variable "ops_config_version" {
  description = "version of ops repository used to generate the configuration"
  default     = "{{cookiecutter.ops_config_version}}"
}

locals {
  env          = "${var.env}${var.env_inst}"
  cluster_name = "${var.cluster_name_prefix}-${local.env}"
}
