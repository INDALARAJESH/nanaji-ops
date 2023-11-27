variable "subnet_tag" {
  description = "subnet tag for instance placement"
  default     = "private_base"
}

variable "subnet_tag_filter" {
  description = "used in subnet lookups. allows lookups based on Name, etc"
  default     = "NetworkZone"
}

variable "custom_vpc_name" {
  description = "custom vpc name for resource placement"
  default     = ""
}

variable "private_zone_boolean" {
  description = "Toggle private or public zone"
  default     = true
}
