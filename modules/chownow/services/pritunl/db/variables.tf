variable "env" {
  description = "unique environment/stage name"
}

variable "service" {
  description = "unique service name"
  default     = "pritunl"
}

variable "vpc_name" {
  description = "name of vpc for resource placement"
}

variable "mongodb_instances" {
  description = "mongodb name, instance size, and subnet id"
}

variable "dns_zone" {
  description = "private dns zone for record creation"
  default     = ""
}

locals {
  dns_zone = var.dns_zone == "" ? "${var.env}.aws.chownow.com" : var.dns_zone
}
