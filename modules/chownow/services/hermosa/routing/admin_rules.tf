# Routes all "cloudkitchen" user agent requests to cloudkitchens admin ck instances
module "admin_listener_rule_ck_weighted" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group ? 0 : 1
  env                    = var.env
  env_inst               = var.env_inst
  http_header_values     = var.isolated_useragents
  listener_arn           = data.aws_lb_listener.admin.arn
  service                = var.service
  listener_rule_priority = var.listener_rule_priority
  weighted_target_groups = local.admin_ck_target_groups
}

module "admin_listener_rule_ck_one_target" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group ? 1 : 0
  env                    = var.env
  env_inst               = var.env_inst
  http_header_values     = var.isolated_useragents
  listener_arn           = data.aws_lb_listener.admin.arn
  service                = var.service
  listener_rule_priority = var.listener_rule_priority
  target_group_arns      = [local.admin_ck_target_group_arn]
}

# Allows access to admin paths
module "admin_listener_rule_admin_weighted" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group ? 0 : 1
  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = data.aws_lb_listener.admin.arn
  path_pattern_values    = ["/admin*", "/static*", "/favicon.ico", "/api*", "/forgot*"]
  service                = var.service
  listener_rule_priority = var.listener_rule_priority + var.listener_rule_priority_interval
  weighted_target_groups = local.admin_target_groups
}

module "admin_listener_rule_admin_one_target" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group ? 1 : 0
  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = data.aws_lb_listener.admin.arn
  path_pattern_values    = ["/admin*", "/static*", "/favicon.ico", "/api*", "/forgot*"]
  service                = var.service
  listener_rule_priority = var.listener_rule_priority + var.listener_rule_priority_interval
  target_group_arns      = [local.admin_target_group_arn]
}
