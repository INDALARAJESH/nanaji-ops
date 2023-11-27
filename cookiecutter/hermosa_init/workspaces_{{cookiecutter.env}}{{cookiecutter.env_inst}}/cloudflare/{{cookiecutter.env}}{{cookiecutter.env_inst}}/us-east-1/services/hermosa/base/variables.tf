variable "domain" {
  default = "svpn.chownow.com"
}

variable "subdomains" {
  default = ["admin", "api"]
}

locals {
  env = "${var.env}${var.env_inst}"
}
