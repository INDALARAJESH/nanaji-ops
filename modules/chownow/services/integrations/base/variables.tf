variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to qa01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "integrations"
}

variable "service_id" {
  description = "unique service identifier, eg '-in' => middleware-in"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to launch databases in"
  default     = "nc"
}

variable "enable_alb" {
  default = 1
}

variable "domain_public" {
  description = "public domain name information"
  default     = "svpn.chownow.com"
}

variable "subdomains" {
  description = "list of subdomains to record in route53 for this ALB"
  default     = []
}

locals {
  env               = "${var.env}${var.env_inst}"
  service           = "${var.service}${var.service_id}"
  alb_log_bucket    = "${var.service}-alb-${local.env}-logs"
  dns_domain        = "${local.env}.${var.domain_public}"
  default_subdomain = "${local.service}-origin"

  common_tags = map(
    "Environment", local.env,
    "EnvironmentInstance", var.env_inst,
    "Service", local.service,
    "ManagedBy", var.tag_managed_by,
  )
}
