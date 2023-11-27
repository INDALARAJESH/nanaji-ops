variable "env" {
  description = "Name of AWS env"
}

variable "env_inst" {
  description = "AWS environment instance count"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "vpc_tag_name" {
  description = "tag:Name for the VPC where the endpoint will be created"
  type        = string
}

locals {
  env = "${var.env}${var.env_inst}"

  common_tags = {
    "Environment"         = var.env,
    "EnvironmentInstance" = var.env_inst,
    "ManagedBy"           = var.tag_managed_by,
    "VPC"                 = data.aws_vpc.selected.id,
    "TFModule"            = "modules/aws/vpc-endpoint/gateway",
  }

  # Format contingent on endpoint type
  # Gateway endpoint service_name format: com.amazonaws.region.service
  gateway_service_name = "com.amazonaws.${data.aws_region.current.name}.${var.service_name}"
}
