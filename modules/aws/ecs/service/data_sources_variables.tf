variable "vpc_name_prefix" {
  description = "VPC name which is used to determine where to create resources"
  default     = ""
}

variable "custom_vpc_name" {
  description = "VPC name which is used to determine where to create resources"
  default     = ""
}

variable "vpc_private_subnet_tag_key" {
  description = "Used to filter down available subnets"
  default     = "private_base"
}

variable "vpc_public_subnet_tag_key" {
  description = "Used to filter down available subnets"
  default     = "public_base"
}
