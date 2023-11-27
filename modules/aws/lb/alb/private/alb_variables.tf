###########
# General #
###########

variable "vpc_id" {
  description = "VPC ID for resource creation"
}

variable "certificate_arn" {
  description = "ARN for certificate to be used by ALB"
}

variable "security_group_ids" {
  description = "list of security ID groups for ALB"
  default     = []
}

variable "custom_alb_log_bucket" {
  description = "alb log bucket name"
  default     = ""
}

variable "access_logs_enabled" {
  description = "boolean to enable/disable logging"
  default     = true
}

##########################
# ALB Listener Variables #
##########################

variable "listener_port" {
  description = "ALB listener port"
  default     = "443"
}

variable "listener_protocol" {
  description = "ALB listener protocol"
  default     = "HTTPS"
}

variable "listener_ssl_policy" {
  description = "ALB listener ssl policy"
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "listener_da_type" {
  description = "ALB listener default action type"
  default     = "fixed-response"
}

variable "listener_da_fixed_content_type" {
  description = "ALB listener default action fixed response content type"
  default     = "text/plain"
}

variable "listener_da_fixed_status_code" {
  description = "ALB listener default action fixed response status code"
  default     = "421"
}

variable "enable_http_to_https_redirect" {
  description = "enables http to http redirect"
  default     = 0
}

##############################
# ALB Target Group Variables #
##############################

variable "health_check_target" {
  description = "The target to check for the load balancer."
  default     = "/statuscode/200"
}

variable "tg_port" {
  description = "custom port for target group"
  default     = ""
}

variable "health_check_matcher" {
  description = "ALB target group health check matcher"
  default     = "200"
}

#####################
# ALB DNS Variables #
#####################

variable "cname_subdomain_alb" {
  description = "subdomain name for cname creation"
  default     = ""
}

variable "r53_type" {
  description = "ALB Route53 record type"
  default     = "CNAME"
}

variable "r53_ttl" {
  description = "ALB Route53 record ttl"
  default     = "300"
}
