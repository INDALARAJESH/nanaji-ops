variable "image_uri" {
  description = "ECR image uri"
  type        = string
}

variable "api_gateway_priv_vpce_list" {
  description = "List of VPC Endpoint Interface IDs (ie. `vpce-04d46c5fb680e2317`) to be permitted on Private API Gateway Resource Policy"
  default     = []
}

variable "public_api_gw_resource_policy_enabled" {
  description = "Whether to enable resource policy (ie. filtering traffic only from Cloudflare) for Public API Gateway"
  type        = bool
  default     = false
}

variable "pos_vendor_oauth_client_id" {
  description = "Value of POS_VENDOR_OAUTH_CLIENT_ID variable"
  type        = string
  default     = ""
}

variable "logger_log_event" {
  description = "Value of LOGGER_LOG_EVENT variable"
  type        = string
  default     = "False"
}

variable "debug" {
  description = "Value of DEBUG variable"
  type        = string
  default     = "False"
}

variable "log_level" {
  description = "Value of LOG_LEVEL variable"
  type        = string
  default     = "INFO"
}

variable "mocked_pos_vendor_api" {
  description = "Value of MOCKED_POS_VENDOR_API variable"
  type        = string
  default     = "False"
}

variable "mocked_api_random_response_time" {
  description = "Value of MOCKED_API_RANDOM_RESPONSE_TIME variable"
  type        = string
  default     = "False"
}

variable "metrics_is_enabled" {
  description = "Pythonic boolean - whether app should push metrics to DD"
  type        = string
  default     = "True"
}

variable "metrics_service_name" {
  description = "Service name for the metrics to be pushed as to DD"
  type        = string
  default     = "square"
}

variable "pos_vendor_is_sandbox" {
  description = "Value of POS_VENDOR_IS_SANDBOX variable"
  type        = string
  default     = "True"
}

variable "pos_vendor_api_url" {
  description = "Value of POS_VENDOR_API_URL variable"
  type        = string
  default     = "https://connect.squareupsandbox.com"
}

variable "steaks_webhook_enabled" {
  description = "Value of STEAKS_WEBHOOK_ENABLED variable"
  type        = string
  default     = "True"
}

variable "redis_cache_ssl" {
  description = "Pythonic boolean - SSL For Elasticache Redis"
  type        = string
  default     = "True"
}

variable "sf_api_is_sandbox" {
  description = "Value of SF_API_IS_SANDBOX variable"
  type        = string
  default     = "False"
}

variable "sf_api_username" {
  description = "Value of SF_API_USERNAME variable"
  type        = string
  default     = ""
}

variable "hermosa_custom_dashboard_url" {
  description = "Value of HERMOSA_DASHBOARD_URL variable"
  type        = string
  default     = ""
}

variable "pos_vendor_refund_webhook_url" {
  description = "Value of POS_VENDOR_REFUND_WEBHOOK_URL variable"
  type        = string
  default     = ""
}

variable "cloudflare_cidr_block_list" {
  description = "Cloudflare’s current IP ranges taken from https://www.cloudflare.com/ips-v4"
  type        = list(any)
  default     = ["173.245.48.0/20", "103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "141.101.64.0/18", "108.162.192.0/18", "190.93.240.0/20", "188.114.96.0/20", "197.234.240.0/22", "198.41.128.0/17", "162.158.0.0/15", "104.16.0.0/13", "104.24.0.0/14", "172.64.0.0/13", "131.0.72.0/22"]
}

locals {
  hermosa_dashboard_url = var.hermosa_custom_dashboard_url == "" ? "https://app-dashboard.${local.env}.svpn.chownow.com" : var.hermosa_custom_dashboard_url
}
