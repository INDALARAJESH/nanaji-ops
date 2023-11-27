variable "aws_waf_web_acl_id" {
  description = "WAF Web ACL id"
}

variable "origin_path" {
  description = "An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. It must begin with a /. Do not add a / at the end of the path."
  default     = ""
}


variable "allowed_methods" {
  description = "List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront"
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD)"
  default     = ["GET", "HEAD"]
}

variable "cache_policy_id" {
  description = "Cache Policy ID"
  default     = null
}

variable "response_headers_policy_id" {
  default = null
}

variable "forward_query_string" {
  description = "Forward query strings to the origin that is associated with this cache behavior (incompatible with `cache_policy_id`)"
  default     = false
}

variable "query_string_cache_keys" {
  description = "When `forward_query_string` is enabled, only the query string keys listed in this argument are cached (incompatible with `cache_policy_id`)"
  default     = []
}

variable "forward_header_values" {
  description = "A list of whitelisted header values to forward to the origin (incompatible with `cache_policy_id`)"
  default     = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
}

variable "forward_cookies" {
  type        = string
  default     = "none"
  description = "Specifies whether you want CloudFront to forward all or no cookies to the origin. Can be 'all' or 'none'"
}

variable "custom_error_responses" {
  description = "List of one or more custom error response element maps"
  default     = []
}

variable "custom_headers" {
  default = []
}

variable "forwarded_values" {
  default = []
}

variable "whitelisted_names" {
  default = []
}
