variable "enable_zone_svpn_public" {
  description = "enable/disable public svpn zone"
  default     = 1
}

variable "enable_record_caa" {
  description = "ability to turn on/off caa record creation"
  default     = 1
}

variable "enable_zone_chownowcdn" {
  description = "enable/disable public chownowcdn zone"
  default     = 1
}

variable "enable_record_caa_chownowcdn" {
  description = "ability to turn on/off caa record creation for chownowcdn"
  default     = 1
}

variable "enable_zone_chownowapi" {
  description = "enable/disable public chownowapi zone"
  default     = 1
}

variable "enable_record_caa_chownowapi" {
  description = "ability to turn on/off caa record creation for chownowapi"
  default     = 1
}

variable "caa_type" {
  description = "record type for CAA entries"
  default     = "CAA"
}

variable "caa_records" {
  description = "list of CAA records for cloudflare certificate creation"
  default = [
    "0 iodef \"mailto:security@chownow.com\"",
    "0 issue \"digicert.com\"",
    "0 issue \"amazonaws.com\"",
    "0 issuewild \"amazonaws.com\"",
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"digicert.com\""
  ]
}
