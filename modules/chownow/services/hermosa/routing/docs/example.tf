# Example: standard blue-green
module "routing" {
  source                          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/routing?ref=cn-hermosa-routing-v2.1.0"
  env                             = var.env
  env_inst                        = var.env_inst
  listener_rule_priority_interval = var.listener_rule_priority_interval
  listener_rule_priority          = var.listener_rule_priority
  isolated_useragents             = var.isolated_user_agents
  api_alb_name                    = local.api_alb_name
  admin_alb_name                  = local.admin_alb_name
  target_group_admin_blue         = local.target_group_admin_blue
  target_group_admin_ck_blue      = local.target_group_admin_ck_blue
  target_group_api_blue           = local.target_group_api_blue
  target_group_admin_green        = local.target_group_admin_green
  target_group_admin_ck_green     = local.target_group_admin_ck_green
  target_group_api_green          = local.target_group_api_green
  traffic_distribution_api        = var.traffic_distribution_api
  traffic_distribution_admin      = var.traffic_distribution_admin
  traffic_distribution_admin_ck   = var.traffic_distribution_admin_ck
}

# Example: with webhookproxy alb
module "routing_webhook" {
  source                          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/routing?ref=cn-hermosa-routing-v2.1.0"
  env                             = var.env
  env_inst                        = var.env_inst
  listener_rule_priority_interval = var.listener_rule_priority_interval
  listener_rule_priority          = var.listener_rule_priority
  isolated_useragents             = var.isolated_user_agents
  api_alb_name                    = local.api_alb_name
  admin_alb_name                  = local.admin_alb_name
  enable_webhook                  = true
  webhook_alb_name                = "webhookproxy-alb"
  target_group_admin_blue         = local.target_group_admin_blue
  target_group_admin_ck_blue      = local.target_group_admin_ck_blue
  target_group_api_blue           = local.target_group_api_blue
  target_group_webhook_blue       = local.target_group_webhook_blue
  target_group_admin_green        = local.target_group_admin_green
  target_group_admin_ck_green     = local.target_group_admin_ck_green
  target_group_api_green          = local.target_group_api_green
  target_group_webhook_green      = local.target_group_webhook_green
  traffic_distribution_api        = var.traffic_distribution_api
  traffic_distribution_admin      = var.traffic_distribution_admin
  traffic_distribution_admin_ck   = var.traffic_distribution_admin_ck
}

# Example: single target groups (no traffic disdtribution)
module "routing_single" {
  source                          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/routing?ref=cn-hermosa-routing-v2.1.0"
  env                             = var.env
  env_inst                        = var.env_inst
  listener_rule_priority_interval = var.listener_rule_priority_interval
  listener_rule_priority          = var.listener_rule_priority
  isolated_useragents             = var.isolated_user_agents
  api_alb_name                    = local.api_alb_name
  admin_alb_name                  = local.admin_alb_name
  enable_webhook                  = true
  webhook_alb_name                = "webhookproxy-alb"
  target_group_admin_blue         = local.target_group_admin_blue
  target_group_admin_ck_blue      = local.target_group_admin_ck_blue
  target_group_api_blue           = local.target_group_api_blue
  target_group_webhook_blue       = local.target_group_webhook_blue
  target_group_admin_green        = local.target_group_admin_green
  target_group_admin_ck_green     = local.target_group_admin_ck_green
  target_group_api_green          = local.target_group_api_green
  target_group_webhook_green      = local.target_group_webhook_green
  traffic_distribution_api        = var.traffic_distribution_api
  traffic_distribution_admin      = var.traffic_distribution_admin
  traffic_distribution_admin_ck   = var.traffic_distribution_admin_ck
  api_target_groups               = []
  single_target_group             = true
}
