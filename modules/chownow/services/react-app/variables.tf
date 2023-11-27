variable "env" {
  description = "unique environment/stage name"
}

variable "service" {
  description = "name of service, used in interpolations"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "subdomain" {
  description = "subdomain name information"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "wildcard_domain_prefix" {
  description = "Custom prefix used for looking up wild card cert (sometimes = '*.')"
  default     = ""
}

variable "extra_tags" {
  description = "additional tags"
  default     = {}
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "overwrite_zone_ids" {
  description = "list of zone IDs corresponding to the list of app_domains"
  default     = ""
}

locals {
  env = "${var.env}${var.env_inst}"

  # Interpolate DNS zone for cert
  dns_zone  = var.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  subdomain = var.subdomain != "" ? var.subdomain : var.service

  # Codebuild environment variables will NOT interpolate resource refs, so this crap exists
  s3_bucket_name = "cn-${var.service}-${local.env}"

  # these are "standard" and will be merged with user-provided
  codebuild_environment_variables = [
    {
      name  = "ENV"
      value = local.env
      type  = "PLAINTEXT"
    }
  ]

  common_tags = map(
    "Environment", local.env,
    "Service", var.service,
    "ManagedBy", var.tag_managed_by,
  )
}
