variable "wildcard_domain_prefix" {
  description = "allows for the addition of wildcard to the name because some chownow accounts have it"
  default     = ""
}


variable "custom_vpc_name" {
  description = "override for vpc to use for resource placement"
  default     = ""
}

variable "vpc_name_prefix" {
  description = "name prefix to use for VPC"
  default     = "main"
}

variable "name_prefix" {
  description = "name prefix"
  default     = "cn"
}
