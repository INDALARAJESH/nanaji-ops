variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  default = "chownow.com"
}

variable "service" {
  default = "gdpr-redirect"
}

variable "name_prefix" {
  default = "cn"
}

variable "dns_ttl" {
  default = "300"
}

# GDPR Redirect Domains
variable "gpdr_redirect_domains" {
  default = [
  ]
}

variable "aws_assume_role_name" {
  default = "OrganizationAccountAccessRole"
}

# ---------------------------------------------------------------------------------------------------------------------
# TAGS
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  type    = map(string)
  default = {}
}

locals {
  env                = "${var.env}${var.env_inst}"
  certificate_domain = var.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  common_tags = map(
    "Environment", var.env,
    "EnvironmentInstance", var.env_inst,
    "TFModule", "modules/chownow/services/gdpr-redirect/base"
  )
  aws_account_id = data.aws_caller_identity.current.account_id
}
