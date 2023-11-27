variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name"
  default     = "security-root-login"
}

variable "alert_subscription_emails" {
  description = "email addresses to send login alerts to"
  type        = set(string)
  default = [
    "ops@chownow.com"
  ]
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}


locals {
  env = "${var.env}${var.env_inst}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }
}
