variable "enable_http_to_https_redirect" {
  description = "enable/disable https redirect"
  default     = 1
}

variable "enable_gdpr_cname_cloudflare" {
  description = "enables/disables cloudflare gdpr cname"
  default     = 1
}

variable "health_check_target" {
  default     = "/statuscode/200"
  description = "The target to check for the load balancer."
}
