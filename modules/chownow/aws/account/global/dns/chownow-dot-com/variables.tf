variable "env" {
  description = "unique environment/stage name"
  default     = "prod"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
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

variable "domain" {
  description = "default domain name for record placement"
  default     = "chownow.com"
}

variable "domain_chownowcdn" {
  description = "default domain name for record placement"
  default     = "chownowcdn.com"
}

variable "aws_assume_role_name" {
  default = "OrganizationAccountAccessRole"
}

locals {
  env = "${var.env}${var.env_inst}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }
}

