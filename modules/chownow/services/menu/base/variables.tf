variable "env" {
  description = "unique environment/stage name"
  default     = "dev"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "menu"
}

variable "service_id" {
  description = "unique service identifier, eg '-in' => integrations-in"
  default     = ""
}

variable "vpc_name_prefix" {
  description = "prefix added to var.env to select which vpc the service will on"
  type        = string
  default     = "main"
}

variable "domain" {
  description = "domain name information, e.g. chownow.com"
  default     = "chownow.com"
}

variable "container_web_port" {
  description = "web container ingress tcp port, e.g. 8003"
  default     = "8003"
}

##############################
# ALB Variables #
##############################

variable "enable_alb_web" {
  description = "enables/disables alb creation"
  default     = 1
}

variable "tg_health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  default     = 2
}

variable "tg_health_check_interval" {
  description = "seconds between heath check"
  default     = 30
}

variable "tg_health_check_target" {
  description = "ALB target group health check target"
  default     = "/health"
}

variable "tg_health_check_timeout" {
  description = "seconds when no response means a failed health check"
  default     = 2
}

variable "alb_tg_target_type" {
  description = "ALB target group target type"
  default     = "ip"
}

variable "alb_tg_listener_protocol" {
  description = "ALB Listener protocol"
  default     = "HTTP"
}

variable "alb_tg_deregistration_delay" {
  description = "the amount of time a target group waits for a container to drain in seconds"
  default     = 1
}

locals {
  env                = "${var.env}${var.env_inst}"
  container_web_name = "${var.service}-web-${local.env}"
  dns_zone           = "${local.env}.svpn.${var.domain}"
  service            = "${var.service}${var.service_id}"
}
