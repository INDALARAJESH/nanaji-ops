variable "enable_alb_web" {
  description = "enables/disables web alb creation"
  default     = 1
}

variable "enable_cloudflare" {
  description = "enables/disables cloudflare records creation"
  default     = 1
}

variable "enable_eat" {
  description = "enables/disables eat. related resources"
  default     = 1
}

variable "web_cname_cloudflare" {
  description = "cname subdomain to use for web"
  default     = "web"
}

variable "web_cname_alb" {
  description = "cname subdomain in chownow zone for web"
  default     = "web-origin"
}

variable "cloudflare_domain" {
  description = "cloudflare domain to be appended to the end of cname desination"
  default     = "cdn.cloudflare.net"
}

variable "web_healthcheck_target" {
  description = "health check path for web ALB"
  default     = "/statuscode/200"
}

############################
# Admin Redirect Variables #
############################

variable "ar_lr_action_type" {
  description = "admin redirect listener rule action type"
  default     = "redirect"
}

variable "ar_path_destination" {
  description = "admin redirect path destination"
  default     = "/#{path}"
}

variable "ar_query" {
  description = "admin redirect query"
  default     = "#{query}"
}

variable "ar_target_group_arn" {
  description = "admin redirect target group ARN"
  default     = "null"
}

###################
# API Variables #
###################

variable "subdomain_api" {
  description = "api subdomain for route53 record creation"
  default     = "api"
}

variable "ttl_api" {
  description = "api cname record ttl"
  default     = 60
}

#################
# Eat Variables #
#################

variable "subdomain_eat" {
  description = "eat subdomian for route53 record creation"
  default     = "eat"
}

variable "ttl_eat" {
  description = "eat cname record ttl"
  default     = 60
}

variable "enable_gdpr_cname_eat" {
  description = "a way to enable/disable creation of GDPR cname for eat"
  default     = 1
}


######################
# Ordering Variables #
######################

variable "subdomain_ordering" {
  description = "ordering subdomian for route53 record creation"
  default     = "ordering"
}

variable "ttl_ordering" {
  description = "ordering cname record ttl"
  default     = 60
}

variable "enable_gdpr_cname_ordering" {
  description = "a way to enable/disable creation of GDPR cname for ordering"
  default     = 1
}

######################
# Facebook Variables #
######################

variable "subdomain_facebook" {
  description = "facebook subdomian for route53 record creation"
  default     = "facebook"
}

variable "ttl_facebook" {
  description = "facebook cname record ttl"
  default     = 60
}

variable "enable_gdpr_cname_facebook" {
  description = "a way to enable/disable creation of GDPR cname for facebook"
  default     = 1
}
