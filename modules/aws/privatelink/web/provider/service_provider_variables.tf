##############################
# Service Provider Variables #
##############################

variable "service_provider_vpc_name" {
  description = "name of service provider VPC"
}



#######
# NLB #
#######

variable "service_provider_protocol_tg" {
  description = "healthcheck protocol for target group"
  default     = "HTTPS"
}

variable "service_provider_path_tg" {
  description = "healthcheck path for target group"
  default     = "/health"
}

variable "enable_cross_zone_load_balancing" {
  description = "enable/disable cross zone load balancing on PrivateLink NLB"
  default     = true
}


########################
# VPC Endpoint Service #
########################

variable "service_provider_aws_account_ids" {
  description = "list of AWS account IDs to allow access to the privatelink provider"
  default     = []
}

variable "service_provider_private_dns_name" {
  description = "The DNS name that clients on the consumer side will use to reach the reasource(s) on the provider side"
}
