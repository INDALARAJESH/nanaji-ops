#########################
# ALB General Variables #
#########################

variable "wildcard_domain_prefix" {
  description = "allows for the addition of wildcard to the name because some chownow accounts have it"
  default     = ""
}

variable "alb_logs_enabled" {
  description = "boolean to enable/disable ALB logging"
  default     = false
}

variable "alb_name_prefix" {
  description = "alb security group name prefix"
  default     = "alb-pub"
}

variable "alb_enable_egress_allow_all" {
  description = "allow egress all on alb"
  default     = "1"
}

variable "alb_ingress_tcp_allowed" {
  description = "list of allowed TCP ports"
  default     = ["443"]
}

variable "alb_log_bucket" {
  description = "ALB log bucket name, alb_logs_enabled must be on when assigning a bucket"
  default     = "null"
}

##############################
# ALB Target Group Variables #
##############################

variable "tg_health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  default     = 3
}

variable "tg_health_check_interval" {
  description = "seconds between heath check"
  default     = 10
}

variable "tg_health_check_target" {
  description = "ALB target group health check target"
  default     = "/health"
}

variable "tg_health_check_timeout" {
  description = "seconds when no response means a failed health check"
  default     = 5
}

variable "alb_tg_target_type" {
  description = "ALB target group target type"
  default     = "ip"
}

variable "alb_tg_listener_protocol" {
  description = "ALB Listener protocol"
  default     = "HTTP"
}

variable "alb_tg_deregistration_delay" {
  description = "the amount of time a target group waits for a container to drain in seconds"
  default     = 15
}

#####################
# ALB DNS Variables #
#####################

variable "alb_cname_primary_vpc_svpn_ttl" {
  description = "(optional) describe your variable"
  default     = 300
}


variable "container_port" {
  description = "ingress TCP port for container"
  default     = "8000"
}

variable "enable_alb_public" {
  description = "enables/disables alb creation"
  default     = 1
}
