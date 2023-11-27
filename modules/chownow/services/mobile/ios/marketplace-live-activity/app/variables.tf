variable "env" {
  description = "Environment"
}

variable "env_inst" {
  description = "Environment Instance"
  default     = ""
}

variable "service" {
  description = "The name of the service"
  default     = "marketplace-live-activity"
}

variable "platform_app_name" {
  description = "Service this app belongs to"
  default     = "iOSMarketplaceLiveActivity"
}

variable "sandbox" {
  description = "Sandbox or Production"
  type        = bool
  default     = true
}

variable "apple_team_id" {
  description = "Apple Team ID"
  default     = "B5A97UB9Q7"
}

variable "apple_bundle_id" {
  description = "Apple Bundle ID"
  default     = "com.ChowNow.Marketplace.push-type.liveactivity"
}

locals {
  env                 = "${var.env}${var.env_inst}"
  platform            = var.sandbox ? "APNS_SANDBOX" : "APNS"
  apns_signing_key    = data.aws_secretsmanager_secret_version.apns_signing_key.secret_string
  apns_signing_key_id = data.aws_secretsmanager_secret_version.apns_signing_key_id.secret_string
}
