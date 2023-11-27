variable "vpc_private_subnet_tag_key" {
  description = "Used to filter down available subnets"
  default     = "private_base"
}

variable "order_direct_distribution_id" {
  description = "Used to find order direct cloudfront record"
}

variable "private_zone_boolean" {
  description = "Toggle private or public zone"
  default     = true
}
