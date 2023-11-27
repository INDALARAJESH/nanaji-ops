variable "service" {
  description = "unique service name"
  default     = "mparticle"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "tag_owner" {
  description = "The team which owns these resources"
  default     = "DataEng"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

locals {
  env = "${var.env}${var.env_inst}"

  # mparticle requires this prefix https://docs.mparticle.com/integrations/amazons3/event/
  bucket_name = "mp-forwarding-cn-quarantine-${local.env}"

  #iterable rule app name (any mparticle lambdas require `mpr` prefix)
  ir_app_name = "mpr-ir"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
  }

  extra_tags = {
    TFModule = "modules/chownow/services/mparticle/base"
  }
}
