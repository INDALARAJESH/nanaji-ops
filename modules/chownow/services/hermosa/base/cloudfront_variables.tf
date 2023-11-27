variable "enable_cloudfront_distribution" {
  description = "enable creation of cdn distribution for static assets"
  default     = 1
}

variable "cdn_cnames" {
  default = []
}

variable "price_class" {
  default = "PriceClass_100"
}

variable "geo_target" {
  default = "*"
}

variable "set_id" {
  default = "Default"
}
