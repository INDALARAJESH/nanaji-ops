variable "vpc_name_prefix" {
  description = "VPC name which is used to determine where to create resources"
}

variable "subnet_tag" {
  description = "Toggle public or private subnet"
  default     = "private"
}

variable "is_private" {
  description = "Toggle private or public zone"
  default     = true
}
