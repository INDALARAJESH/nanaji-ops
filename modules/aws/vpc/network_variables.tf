variable "public_subnets" {
  description = "list of public subnet CIDR blocks"
  type        = list(any)
}

variable "private_subnets" {
  description = "list of private subnet CIDR blocks"
  type        = list(any)
}

variable "azs" {
  description = "list of chosen Availability Zones"
  type        = list(any)
}

variable "privatelink_subnets" {
  description = "list of private subnet CIDR blocks"
  type        = list(any)
  default     = []
}
