variable "domain_name" {
  description = "fqdn domain name for dns zone"
}

variable "description" {
  description = "description for dns zone"
}

variable "vpc_id" {
  description = "VPC ID which is required for private DNS zones"
  default     = ""
}

variable "enable_zone" {
  description = "on/off toggle for zone creation"
  default     = "1"
}
