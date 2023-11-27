module "webhook_listener_rule_weighted_group_1" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group ? 0 : var.enable_webhook ? 1 : 0
  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = data.aws_lb_listener.webhook[count.index].arn
  listener_rule_priority = var.listener_rule_priority + var.webhook_rule_priority_offset
  path_pattern_values    = var.webhook_path_patterns_group_1
  service                = var.service
  weighted_target_groups = [
    {
      target_group_arn = data.aws_lb_target_group.webhook_blue[count.index].arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_api], "blue", 100)
    },
    {
      target_group_arn = data.aws_lb_target_group.webhook_green[count.index].arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_api], "green", 0)
    }
  ]
}

module "webhook_listener_rule_one_target_group_1" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group && var.enable_webhook ? 1 : 0
  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = data.aws_lb_listener.webhook[count.index].arn
  listener_rule_priority = var.listener_rule_priority + var.webhook_rule_priority_offset
  path_pattern_values    = var.webhook_path_patterns_group_1
  service                = var.service
  target_group_arns      = [local.webhook_target_group_arn]
}

module "webhook_listener_rule_weighted_group_2" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group ? 0 : var.enable_webhook ? 1 : 0
  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = data.aws_lb_listener.webhook[count.index].arn
  listener_rule_priority = var.listener_rule_priority + var.webhook_rule_priority_offset + 5
  path_pattern_values    = var.webhook_path_patterns_group_2
  service                = var.service
  weighted_target_groups = [
    {
      target_group_arn = data.aws_lb_target_group.webhook_blue[count.index].arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_api], "blue", 100)
    },
    {
      target_group_arn = data.aws_lb_target_group.webhook_green[count.index].arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution_api], "green", 0)
    }
  ]
}

module "webhook_listener_rule_one_target_group_2" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.enable_webhook && var.single_target_group ? 1 : 0
  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = data.aws_lb_listener.webhook[count.index].arn
  listener_rule_priority = var.listener_rule_priority + var.webhook_rule_priority_offset + 5
  path_pattern_values    = var.webhook_path_patterns_group_2
  service                = var.service
  target_group_arns      = [local.webhook_target_group_arn]
}
