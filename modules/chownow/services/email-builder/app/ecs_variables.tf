variable "container_port" {
  description = "ingress TCP port for container"
  default     = "8000"
}

variable "container_protocol" {
  description = "protocol spoken on container_port"
  default     = "HTTP"
}

variable "ecs_log_retention_in_days" {
  description = "number of days to retain log files"
  default     = "30"
}

variable "ecs_service_desired_count" {
  description = "number of services to run per container"
  default     = "1"
}

variable "host_port" {
  description = "host TCP port for container"
  default     = "8000"
}
