variable "zone_id" {
  description = "Route53 Zone ID for record placement"
}

variable "name" {
  description = "Route53 record name"
  default     = ""
}

variable "type" {
  description = "Route53 record type"
  default     = "A"
}

variable "ttl" {
  description = "Route53 record ttl"
  default     = "300"
}

variable "records" {
  description = "Route53 record values"
  type        = list(any)
}

variable "geo_country" {
  description = "geographic routing policy default, * when applied to country means default policy"
  default     = "*"
}

variable "geo_identifier" {
  description = "geographic routing policy unique identifier name"
  default     = "Default"
}

variable "enable_record" {
  description = "ability to turn on/off record creation"
  default     = 1
}

##################
# GDPR Variables #
##################

variable "enable_gdpr_cname" {
  description = "ability to create gdpr cname"
  default     = 0
}

variable "gdpr_destination" {
  description = "cname destination for users coming from EU"
  default     = "d19qcrio9y8d0j.cloudfront.net"
}

variable "gdpr_geo_continent" {
  description = "GDPR geolocation continent, star indicates default policy"
  default     = "EU"
}

variable "gdpr_geo_identifier" {
  description = "GDPR geolocation identity "
  default     = "EU"
}
