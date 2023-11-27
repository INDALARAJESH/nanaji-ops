variable "provider_vpc_private_subnet_tag_key" {
  description = "Used to filter down available subnets on provider vpc"
  default     = ["privatelink"]
  type        = list(string)
}

variable "consumer_vpc_private_subnet_tag_key" {
  description = "Used to filter down available subnets on consumer vpc"
  default     = ["private_base"]
  type        = list(string)
}

variable "service_provider_alb_name" {
  description = "the provider side ALB to attach to the private link NLB as a target group"
}
