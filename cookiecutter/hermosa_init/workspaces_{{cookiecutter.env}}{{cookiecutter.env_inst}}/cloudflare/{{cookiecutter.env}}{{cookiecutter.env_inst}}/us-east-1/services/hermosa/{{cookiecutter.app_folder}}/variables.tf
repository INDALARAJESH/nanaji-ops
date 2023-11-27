variable "domain" {
  default = "svpn.chownow.com"
}

variable "subdomains" {
  default = ["hermosa-green", "admin-hermosa-green"]
}

locals {
  env = "${var.env}${var.env_inst}"
}
