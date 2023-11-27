##########################
# ALB Listener Variables #
##########################

variable "certificate_arn" {
  description = "ARN for certificate to be used by ALB"
}

variable "alb_arn" {
  description = "ALB ARN to attach listener to"
}

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
}

variable "listener_da_fixed_content_type" {
  description = "ALB listener default action fixed response content type"
  default     = "text/plain"
}

variable "listener_da_fixed_status_code" {
  description = "ALB listener default action fixed response status code"
  default     = "403"
}

variable "target_group_arn" {
  description = "required target group ARN when the listener's default action is forward"
  default     = ""
}

######################
# Redirect Variables #
######################

variable "redirect_host" {
  description = "redirect host value"
  default     = ""
}

variable "redirect_query" {
  description = "redirect query value"
  default     = ""
}

variable "redirect_path_destination" {
  description = "the destination path for redirection"
  default     = ""
}

variable "redirect_port" {
  description = "TCP port for redirection"
  default     = "443"
}

variable "redirect_protocol" {
  description = "protocol for redirection"
  default     = "HTTPS"
}

variable "redirect_status_code" {
  description = "status code for redirection"
  default     = "HTTP_301"
}
