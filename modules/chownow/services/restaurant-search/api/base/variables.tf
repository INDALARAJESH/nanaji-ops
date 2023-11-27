variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "numbered instance of the infrastructure. Example: 01"
  default     = ""
}

variable "vpc_name" {
  description = "The name of the VPC that this infrastructure will be created in"
}

variable "service" {
  description = "name of the service"
  default     = "restaurant-search"
}

variable "create_ecr_repo" {
  description = "controls whether an ECR repo is created"
  default     = false
}

variable "custom_domain" {
  description = "custom domain override for application"
  default     = ""
}

variable "allowed_ip_addresses" {
  description = "Origin IPs allowed to access the load balancer"
  default     = []
}

locals {
  env             = "${var.env}${var.env_inst}"
  description     = "port that the underlying application runs on"
  container_port  = 8080
  app_domain_name = var.custom_domain != "" ? var.custom_domain : "${local.env}.svpn.chownow.com"
}
