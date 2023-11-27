variable "web_container_deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds"
  default     = 30
}

variable "web_container_port" {
  description = "web container ingress TCP port"
  default     = "8000"
}

variable "web_container_healthcheck_interval" {
  description = "web container healthcheck interval"
  default     = 30
}

variable "web_container_healthcheck_target" {
  description = "web container healthcheck endpoint"
  default     = "/health"
}
