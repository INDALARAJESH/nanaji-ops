###############################
# ALB Listener Rule Variables #
###############################

variable "listener_arn" {
  description = "ALB listener ARN to attach listener rule to"
}

variable "listener_rule_priority" {
  description = "ALB listener rule priority"
  default     = null
}

variable "target_group_arns" {
  description = "ARN for target groups to attach to listener rule"
  default     = []
}

variable "weighted_target_groups" {
  description = "List of { target_group_arn, weight } to attach to listener rule"
  type        = list(object({ target_group_arn = string, weight = number }))
  default     = []
}

variable "listener_rule_action_type" {
  description = "ALB listener rule action type"
  default     = "forward"
}

variable "host_header_values" {
  description = "ALB listener rule host header list"
  default     = []
}

variable "path_pattern_values" {
  description = "ALB listener rule path pattern list"
  default     = []
}

variable "http_header_values" {
  description = "ALB listener rule http header list"
  default     = []
}

variable "http_header_name" {
  description = "ALB listener http header name"
  default     = "User-Agent"
}



######################
# Redirect Variables #
######################

variable "redirect_host" {
  description = "redirect host value"
  default     = "#{host}"
}

variable "redirect_query" {
  description = "redirect query value"
  default     = ""
}
variable "redirect_path_origin" {
  description = "the origin path(s) to be redirected"
  default     = []
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
