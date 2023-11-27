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

variable "name_prefix" {
  description = "name prefix for security group"
  default     = ""
}

variable "port" {
  description = "TCP port to allow services on the consumer VPC to access services on the provider VPC"
  default     = 443
}

locals {
  dns_zone = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  env      = "${var.env}${var.env_inst}"
  name     = var.name_prefix == "" ? "${var.service}-pvtlnk-${local.env}" : "${var.name_prefix}-${var.service}-pvtlnk-${local.env}"

  # VPC private subnets
  consumer_private_subnet_cidrs = [for s in data.aws_subnet.consumer_private : s.cidr_block]

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }
}
