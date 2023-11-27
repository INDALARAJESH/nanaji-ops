variable "wildcard_domain_prefix" {
  description = "allows for the addition of wildcard to the name because some chownow accounts have it"
  default     = ""
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

variable "custom_alb_log_bucket" {
  description = "ALB log bucket name, alb_logs_enabled must be on when assigning a bucket"
  default     = "null"
}

variable "alb_logs_enabled" {
  description = "boolean to enable/disable ALB logging"
  default     = false
}

variable "tg_health_check_target" {
  description = "ALB target group health check target"
  default     = "/api/health"
}

variable "alb_tg_target_type" {
  description = "ALB target group target type"
  default     = "ip"
}

variable "alb_tg_listener_protocol" {
  description = "ALB Listener protocol"
  default     = "HTTP"
}


variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check."
  default     = 10
}

variable "health_check_interval" {
  description = "ALB target group health check interval in seconds"
  default     = 60
}

locals {
  host_header = local.env == "prod" ? ["eat.chownow.com", "www.chownow.com"] : ["${var.service}.${local.dns_zone}"]
}
