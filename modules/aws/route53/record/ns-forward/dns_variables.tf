variable "domain" {
  description = "base domain name information"
  default     = "chownow.com"
}

variable "subdomain" {
  description = "subdomain name information"
  default     = "svpn"
}

variable "nameservers" {
  description = "list of nameservers from another aws account/environment"
}
