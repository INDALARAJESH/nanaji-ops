variable "container_port" {
  description = "ingress TCP port for container"
  default     = "8443"
}

variable "container_protocol" {
  description = "protocol spoken on container_port"
  default     = "HTTPS"
}

variable "sherlock_scanner_memory_limit" {
  description = "task definition memory limit for scanner"
  default     = "4096"
}
