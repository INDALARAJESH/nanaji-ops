variable "env" {
  description = "unique environment/stage name"
  default     = ""
}

variable "env_inst" {
  default = ""
}

variable "service" {
  default = "yelp"
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

locals {
  env = "${var.env}${var.env_inst}"

  # Interpolate DNS zone for cert
  dns_zone = var.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
}
