variable "env" {
  description = "Environment"
}

variable "env_inst" {
  description = "Environment Instance"
  default     = ""
}

variable "app_name" {
  description = "Name of the SNS Platform Application"
}

variable "platform" {
  description = "The platform that the app is registered with, ex. APNS, APNS_SANDBOX, GCM"
}

variable "platform_credential" {
  description = "Application platform credential"
}

variable "platform_principal" {
  description = "Application platform principal"
  default     = null
}

variable "apple_platform_team_id" {
  description = "The identifier that's assigned to your Apple developer account team"
  default     = null
}

variable "apple_platform_bundle_id" {
  description = "The bundle identifier that's assigned to your iOS app"
  default     = null
}


locals {
  env               = "${var.env}${var.env_inst}"
  platform_app_name = "${var.app_name}-${local.env}"
  platform          = upper(var.platform)
}
