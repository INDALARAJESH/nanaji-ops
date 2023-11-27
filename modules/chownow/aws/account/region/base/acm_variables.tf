variable "enable_cert_wildcard" {
  description = "enables/disables creation of svpn wildcard certificate"
  default     = 1
}

variable "enable_cert_chownowapi" {
  description = "enables/disables creation of chownowapi wildcard certificate"
  default     = 1
}

variable "enable_cert_chownowcdn" {
  description = "enables/disables creation of chownowcdn wildcard certificate"
  default     = 1
}
