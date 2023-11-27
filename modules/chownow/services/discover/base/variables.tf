variable "name_prefix" {
  description = "name prefix"
  default     = ""
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name"
  default = "discover"
}

# ---------------------------------------------------------------------------------------------------------------------
# COMMON RESOURCE TAGGING
# ---------------------------------------------------------------------------------------------------------------------
locals {
  env = "${var.env}${var.env_inst}"
  common_tags = map(
    "Environment", var.env,
    "EnvironmentInstance", "${var.env}${var.env_inst}"
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# TAGS
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  type    = map(string)
  default = {}
}
