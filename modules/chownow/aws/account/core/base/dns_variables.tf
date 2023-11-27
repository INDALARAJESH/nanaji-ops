variable "root_domain" {
  description = "root domain name"
  default     = "chownow.com"
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
