variable "service" {
  description = "unique service name"
  default     = "hermosa-events"
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}
