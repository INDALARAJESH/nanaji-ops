#################
# DNS VARIABLES #
#################

variable "enable_cname_creation" {
  description = "enable/disable cname creation"
  default     = 1
}
variable "db_name_suffix" {
  description = "name suffix for cname"
  default     = "primary"
}

variable "dns_record_ttl" {
  description = "TTL for cname record"
  default     = "900"
}

variable "dns_record_type" {
  description = "database record type"
  default     = "CNAME"
}

variable "custom_cname_endpoint" {
  description = "custom cname endpoint name for A record creation"
  default     = ""
}

variable "custom_cname_endpoint_reader" {
  description = "custom cname endpoint name for A record creation"
  default     = ""
}
