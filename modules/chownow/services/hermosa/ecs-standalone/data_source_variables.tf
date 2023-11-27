variable "wildcard_domain_prefix" {
  description = "allows for the addition of wildcard to the name because some chownow accounts have it"
  default     = ""
}

locals {
  certificate_domain = var.env == "prod" ? "*.${var.domain_public}" : "${var.wildcard_domain_prefix}${local.env}.${var.domain_public}"
}
