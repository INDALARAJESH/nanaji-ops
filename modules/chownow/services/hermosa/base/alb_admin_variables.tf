variable "enable_alb_admin" {
  description = "enables/disables admin alb creation"
  default     = 1
}

variable "admin_cname_cloudflare" {
  description = "cname subdomain to use for admin"
  default     = "admin"
}

variable "admin_cname_alb" {
  description = "cname subdomain in chownow zone for admin"
  default     = "admin-origin"
}

variable "isolated_useragents" {
  description = "list of user agents to route to the bot pool"
  default     = []
}

variable "admin_healthcheck_target" {
  description = "health check path for admin ALB"
  default     = "/statuscode/200"
}

variable "admin_listener_rule_priority" {
  description = "listener rule priority for first admin listener rule"
  default     = 10
}
