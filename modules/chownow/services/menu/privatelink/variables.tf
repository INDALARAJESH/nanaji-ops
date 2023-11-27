variable "env" {
  description = "Unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "Name of app/service"
  default     = "menu"
}

variable "service_consumer_aws_account_id" {
  description = "Service Consumer AWS Account ID"
}

variable "aws_assume_role_name" {
  default = "OrganizationAccountAccessRole"
}

variable "service_provider_vpc_name" {
  default = "nc-dev"
}

variable "service_consumer_vpc_name" {
  default = "main-dev"
}

variable "service_consumer_extra_sg_cidr_blocks" {
  description = "Allows additional CIDR blocks to be added to the VPC endpoint"
  default     = []
}

locals {
  env = "${var.env}${var.env_inst}"
}
