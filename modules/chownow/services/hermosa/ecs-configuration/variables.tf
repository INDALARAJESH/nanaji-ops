variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of service"
  default     = "hermosa"
}

locals {
  // ecs-* services have access to the secrets under ${local.env}/shared-${var.service}/ by convention defined in the CN modules
  service = "shared-${var.service}"
}
