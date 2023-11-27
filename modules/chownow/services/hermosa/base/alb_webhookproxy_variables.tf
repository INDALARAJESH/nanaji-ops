variable "enable_alb_webhookproxy" {
  description = "enables/disables web alb creation"
  default     = 0
}

variable "webhookproxy_cname_cloudflare" {
  description = "cname subdomain to use for webhookproxy"
  default     = "webhookproxy"
}

variable "subdomain_webhookproxy" {
  description = "webhookproxy subdomain for route53 record creation"
  default     = "webhookproxy"
}

variable "ttl_webhookproxy" {
  description = "webhookproxy cname record ttl"
  default     = 60
}
