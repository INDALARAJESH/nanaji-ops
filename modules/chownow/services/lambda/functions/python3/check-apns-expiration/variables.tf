variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance name"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "apns_expiration"
}

variable "platform_application_arns" {
  description = "List of ARNs of APNS SNS platform application"
}

locals {
  env = "${var.env}${var.env_inst}"

  lambda_layer_names = [
    "python3_check_apns_expiration_${local.env}_useast1",
  ]

}
