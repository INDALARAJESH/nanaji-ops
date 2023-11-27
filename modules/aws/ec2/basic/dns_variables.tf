variable "dns_type" {
  description = "DNS record type"
  default     = "A"
}

variable "dns_ttl" {
  description = "TTL for dns record"
  default     = 900
}

variable "enable_dns_record_private" {
  description = "enables/disables private dns zone creation"
  default     = 1
}

variable "enable_dns_record_public" {
  description = "enables/disables public dns zone creation"
  default     = 0
}
