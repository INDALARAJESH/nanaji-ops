variable "service" {
  description = "unique service name"
  default     = "hermosa"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "snapshot_name" {
  description = "name of snapshot to use to restore data. It will create a new resource if changed."
  default     = ""
}

variable "custom_cname_endpoint" {
  description = "custom cname endpoint name for A record creation"
  default     = ""
}

variable "custom_name" {
  description = "customize unique name of the redis cluster."
  default     = ""
}

variable "custom_vpc_name" {
  description = "override vpc name."
  default     = ""
}

variable "availability_zones" {
  description = "override availability zones used for the cache instances"
  default     = []
}

variable "private_dns_zone" {
  description = "use private DNS zone"
  default     = true
}

variable "dns_zone" {
  description = "override DNS zone to use"
  default     = ""
}

locals {
  env = "${var.env}${var.env_inst}"
  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
    TFModule            = "modules/chownow/services/hermosa/redis"
  }
}
