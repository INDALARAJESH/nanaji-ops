variable "app_domains" {
  description = "Domain names accepted by cloudfront"
  type        = list(string)
}

variable "gdpr_destination" {
  description = " destination for users coming from EU"
}

variable "gdpr_geo_continent" {
  description = "GDPR geolocation continent, star indicates default policy"
  default     = "EU"
}
