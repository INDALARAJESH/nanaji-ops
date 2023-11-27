variable "web_ecr_repository_uri" {
  default = "449190145484.dkr.ecr.us-east-1.amazonaws.com/hermosa-nginx"
}

variable "web_container_image_version" {
  default = "{{cookiecutter.hermosa_web_image_tag}}"
}

variable "api_ecr_repository_uri" {
  default = "449190145484.dkr.ecr.us-east-1.amazonaws.com/hermosa"
}

variable "api_container_image_version" {
  default = "{{cookiecutter.hermosa_api_image_tag}}"
}

variable "web_ecs_service_desired_count" {
  default = {{cookiecutter.api_desired_count}}
}

locals {
  alb_name_api                     = "web-hermosa-pub-${local.env}"
  api_alb_hostname                 = "${var.service}-${var.deployment_suffix}-origin.${local.env}.svpn.chownow.com"
  api_cloudflare_hostname          = "${var.service}-${var.deployment_suffix}.${local.env}.svpn.chownow.com"
  alb_name_admin                   = "admin-hermosa-pub-${local.env}"
  admin_alb_hostname               = "admin-${var.service}-${var.deployment_suffix}-origin.${local.env}.svpn.chownow.com"
  admin_cloudflare_hostname        = "admin-${var.service}-${var.deployment_suffix}.${local.env}.svpn.chownow.com"
  admin_ck_alb_hostname            = "admin-ck-${var.service}-${var.deployment_suffix}-origin.${local.env}.svpn.chownow.com"
  admin_ck_cloudflare_hostname     = "admin-ck-${var.service}-${var.deployment_suffix}.${local.env}.svpn.chownow.com"
  alb_name_webhookproxy            = "{{cookiecutter.webhookproxy_alb_name}}"
  webhookproxy_alb_hostname        = "webhookproxy-${var.deployment_suffix}-origin.${local.env}.svpn.chownow.com"
  webhookproxy_cloudflare_hostname = "webhookproxy-${var.deployment_suffix}.${local.env}.svpn.chownow.com"
}
