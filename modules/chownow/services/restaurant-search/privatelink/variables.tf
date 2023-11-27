variable "env" {
  description = "Unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "Name of app/service"
  default     = "restaurant-search"
}

variable "service_consumer_aws_account_id" {
  description = "Service Consumer AWS Account ID"
}

variable "aws_assume_role_name" {
  default = "OrganizationAccountAccessRole"
}

variable "service_provider_vpc_name" {
  description = "PrivateLink service provider VPC name"
}

variable "service_consumer_vpc_name" {
  description = "PrivateLink service consumer VPC name"
}

variable "dns_overwrite" {
  description = "Overwrites var.service for DNS name"
  default     = "search"
}

variable "service_consumer_extra_sg_cidr_blocks" {
  description = "Allows additional CIDR blocks to be added to the VPC endpoint"
  default     = []
}

locals {
  env = "${var.env}${var.env_inst}"

  dns_name = var.dns_overwrite != "" ? var.dns_overwrite : var.service
}
