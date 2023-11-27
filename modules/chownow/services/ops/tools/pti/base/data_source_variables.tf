variable "subnet_tag_private" {
  description = "subnet tag for instance placement"
  default     = "private_base"
}

variable "subnet_tag_public" {
  description = "subnet tag for instance placement"
  default     = "public_base"
}

variable "private_zone_boolean" {
  description = "Toggle private or public zone"
  default     = true
}
