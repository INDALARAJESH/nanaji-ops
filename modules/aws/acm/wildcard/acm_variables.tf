variable "dns_zone_name" {
  description = "DNS zone for certificate validation"
}

variable "cert_prefix" {
  description = "certificate prefix"
  default     = "*"
}

variable "cert_validation_method" {
  description = "certifcate validation method, it can be DNS or email"
  default     = "DNS"
}

variable "subject_alternative_names" {
  description = "list of additional domains for certificate"
  default     = []
}

locals {
  subject_alternative_names = ["${var.cert_prefix}.${var.dns_zone_name}"]
}
