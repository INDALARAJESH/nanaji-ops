variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "hermosa"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "main"
}

variable "listener_rule_priority" {
  description = "priority of first listener rules. Others are of increased priority by var.listener_rule_priority_interval"
  default     = 5
}

variable "listener_rule_priority_interval" {
  description = "interval between listener rule priorities"
  default     = 5
}

variable "traffic_distribution_admin" {
  description = "admin levels of traffic distribution"
  type        = string
  default     = "blue"
}

variable "traffic_distribution_admin_ck" {
  description = "admin_ck levels of traffic distribution"
  type        = string
  default     = "blue"
}

variable "traffic_distribution_api" {
  description = "api levels of traffic distribution"
  type        = string
  default     = "blue"
}

variable "target_group_admin_blue" {
  description = "admin blue deployment target group"
}

variable "target_group_admin_green" {
  description = "admin green deployment target group"
}

variable "target_group_admin_ck_blue" {
  description = "admin_ck blue deployment target group"
}

variable "target_group_admin_ck_green" {
  description = "admin _ck green deployment target group"
}

variable "target_group_api_blue" {
  description = "api blue deployment target group"
}

variable "target_group_api_green" {
  description = "api green deployment target group"
}

variable "target_group_webhook_blue" {
  description = "webhook blue deployment target group"
  default     = ""
}

variable "target_group_webhook_green" {
  description = "webhook green deployment target group"
  default     = ""
}

variable "isolated_useragents" {
  description = "list of user agents to route to the admin_ck pool"
  default     = ["cloudkitchens", "CubohBot/*", "OrderRobot/*"]
}

variable "ar_path_destination" {
  description = "admin redirect path destination"
  default     = "/#{path}"
}

variable "ar_query" {
  description = "admin redirect query"
  default     = "#{query}"
}

variable "subdomain_api" {
  description = "api subdomain"
  default     = "api"
}

variable "subdomain_facebook" {
  description = "facebook subdomain"
  default     = "facebook"
}

variable "subdomain_eat" {
  description = "eat subdomain"
  default     = "eat"
}

variable "subdomain_ordering" {
  description = "ordering subdomain"
  default     = "ordering"
}

variable "domain" {
  description = "domain name"
  default     = "chownow.com"
}

variable "admin_alb_name" {
  description = "admin ALB name"
}

variable "api_alb_name" {
  description = "api ALB name"
}

variable "single_target_group" {
  description = "allows to force using a single target group to allow deletion of the unused target group"
  default     = false
}

variable "enable_webhook" {
  description = "allows to create listener rules for the webhook ALB listener"
  default     = false
}

variable "webhook_alb_name" {
  description = "webhook ALB name"
  default     = ""
}

variable "webhook_rule_priority_offset" {
  description = "priority offset for listener rule"
  default     = 100
}

variable "webhook_path_patterns_group_1" {
  description = "path patterns group 1 (5 max) to match and route on webhook ALB"
  default = [
    "/yelp/*",
    "/api/yelp/*",
    "/api/webhook",
    "/api/webhook/*",
  ]
}

variable "webhook_path_patterns_group_2" {
  description = "path patterns group 2 (5 max) to match and route on webhook ALB"
  default = [
    "/.well-known/apple-developer-merchantid-domain-association",
    "/api/google-food",
    "/api/google-food/*"
  ]
}

variable "api_target_groups" {
  description = "Optional custom list of target groups for api load balancer rules"
  default     = []
}

variable "admin_target_groups" {
  description = "Optional custom list of target groups for admin load balancer rules"
  default     = []
}

variable "admin_ck_target_groups" {
  description = "Optional custom list of target groups for admin_ck load balancer rules"
  default     = []
}

locals {
  aws_account_id            = data.aws_caller_identity.current.account_id
  env                       = "${var.env}${var.env_inst}"
  region                    = data.aws_region.current.name
  dns_zone                  = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  vpc_name                  = var.vpc_name_prefix != "" ? "${var.vpc_name_prefix}-${local.env}" : local.env
  api_target_group_arn      = var.traffic_distribution_api == "blue" ? data.aws_lb_target_group.api_blue.arn : var.traffic_distribution_api == "green" ? data.aws_lb_target_group.api_green.arn : ""
  admin_target_group_arn    = var.traffic_distribution_admin == "blue" ? data.aws_lb_target_group.admin_blue.arn : var.traffic_distribution_admin == "green" ? data.aws_lb_target_group.admin_green.arn : ""
  admin_ck_target_group_arn = var.traffic_distribution_admin_ck == "blue" ? data.aws_lb_target_group.admin_ck_blue.arn : var.traffic_distribution_admin == "green" ? data.aws_lb_target_group.admin_ck_green.arn : ""
  webhook_target_group_arn  = var.enable_webhook == false ? "" : var.traffic_distribution_api == "blue" ? data.aws_lb_target_group.webhook_blue[0].arn : var.traffic_distribution_api == "green" ? data.aws_lb_target_group.webhook_green[0].arn : ""
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    blue-80 = {
      blue  = 80
      green = 20
    }
    blue-70 = {
      blue  = 70
      green = 30
    }
    blue-60 = {
      blue  = 60
      green = 40
    }
    split = {
      blue  = 50
      green = 50
    }
    green-60 = {
      blue  = 40
      green = 60
    }
    green-70 = {
      blue  = 30
      green = 70
    }
    green-80 = {
      blue  = 20
      green = 80
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
  api_target_groups = length(var.api_target_groups) == 0 ? [
    {
      target_group_arn = data.aws_lb_target_group.api_blue.arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_api], "blue", 100)
    },
    {
      target_group_arn = data.aws_lb_target_group.api_green.arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_api], "green", 0)
    }
  ] : var.api_target_groups
  admin_target_groups = length(var.admin_target_groups) == 0 ? [
    {
      target_group_arn = data.aws_lb_target_group.admin_blue.arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_admin], "blue", 100)
    },
    {
      target_group_arn = data.aws_lb_target_group.admin_green.arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_admin], "green", 0)
    }
  ] : var.admin_target_groups
  admin_ck_target_groups = length(var.admin_ck_target_groups) == 0 ? [
    {
      target_group_arn = data.aws_lb_target_group.admin_ck_blue.arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_admin_ck], "blue", 100)
    },
    {
      target_group_arn = data.aws_lb_target_group.admin_ck_green.arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_admin_ck], "green", 0)
    }
  ] : var.admin_ck_target_groups
}
