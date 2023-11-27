variable "vpc_id" {
  description = "VPC ID for resource creation"
}

variable "alb_tg_target_type" {
  description = "type of the targets to register (valid values are instance, ip, lambda)"
  default     = "instance"
}

variable "target_group_name" {
  description = "allow to set the target group name entirely"
  default     = ""
}

variable "alb_name" {
  description = "alb name to associate this target group with"
}

variable "alb_listener_protocol" {
  description = "ALB listener protocol"
  default     = "HTTPS"
}

variable "health_check_target" {
  description = "The target to check for the load balancer."
  default     = "/statuscode/200"
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check."
  default     = 5
}

variable "health_check_matcher" {
  description = "ALB target group health check matcher"
  default     = "200"
}

variable "health_check_interval" {
  description = "ALB target group health check interval in seconds"
  default     = 30
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive health check successes required before considering an unhealthy target healthy"
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering the target unhealthy"
  default     = 3
}

variable "tg_port" {
  description = "custom port for target group"
  default     = "443"
}

variable "deregistration_delay" {
  description = "seconds to wait before changing the state from draining to unused"
  default     = "120"
}

variable "name_suffix" {
  description = "unique identifier to add to target group name"
  default     = ""
}
