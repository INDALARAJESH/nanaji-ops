variable "service" {
  default = "hermosa"
}

variable "blue_service" {
  default = "hermosa"
}

variable "green_service" {
  default = "hermosa"
}

variable "traffic_distribution_api" {
  default = "{{cookiecutter.deployment_suffix}}"
}

variable "traffic_distribution_admin" {
  default = "{{cookiecutter.deployment_suffix}}"
}

variable "traffic_distribution_admin_ck" {
  default = "{{cookiecutter.deployment_suffix}}"
}

variable "listener_rule_priority_interval" {
  default = 2
}
variable "listener_rule_priority" {
  description = "first rule priority"
  default     = 10
}

variable "domain_public" {
  description = "public domain name information"
  default     = "svpn.chownow.com"
}

variable "isolated_user_agents" {
  description = "user-agent header values to forward to admin_ck target group"
  default     = ["cloudkitchens", "CubohBot/*", "OrderRobot/*"]
}

locals {
  env                         = "${var.env}${var.env_inst}"
  admin_alb_name              = "admin-${var.service}-pub-${local.env}"
  api_alb_name                = "web-${var.service}-pub-${local.env}"
  target_group_admin_blue     = "${var.blue_service}-admin-blue-${local.env}"
  target_group_admin_ck_blue  = "${var.blue_service}-admin-ck-blue-${local.env}"
  target_group_api_blue       = "${var.blue_service}-api-blue-${local.env}"
  target_group_webhook_blue   = "webhook-${var.blue_service}-api-blue-${local.env}"
  target_group_admin_green    = "${var.green_service}-admin-green-${local.env}"
  target_group_admin_ck_green = "${var.green_service}-admin-ck-green-${local.env}"
  target_group_api_green      = "${var.green_service}-api-green-${local.env}"
  target_group_webhook_green  = "webhook-${var.green_service}-api-green-${local.env}"
}
