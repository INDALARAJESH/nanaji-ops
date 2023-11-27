# This rule is necessary because the path `/admin` should be served by the admin instances.
# The rule redirects to admin.chownow.com (or admin.ENV.svpn.chownow.com)
module "api_listener_rule_admin_redirect" {
  source                    = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  env                       = var.env
  env_inst                  = var.env_inst
  listener_arn              = data.aws_lb_listener.api.arn
  listener_rule_action_type = "redirect"
  listener_rule_priority    = var.listener_rule_priority
  redirect_host             = "admin.${local.dns_zone}"
  redirect_path_destination = var.ar_path_destination
  redirect_path_origin      = ["/admin*"]
  redirect_query            = var.ar_query
  service                   = var.service
  target_group_arns         = []
}

# Api subdomain listener rule to forward requests based on host header
module "api_listener_rule_weighted" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group ? 0 : 1
  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = data.aws_lb_listener.api.arn
  listener_rule_priority = var.listener_rule_priority + var.listener_rule_priority_interval
  host_header_values = [
    "${var.subdomain_api}.${local.dns_zone}",
    "${var.subdomain_eat}.${local.dns_zone}",
    "${var.subdomain_ordering}.${local.dns_zone}",
    "${var.subdomain_facebook}.${local.dns_zone}"
  ]
  service                = var.service
  weighted_target_groups = local.api_target_groups
}

module "api_listener_rule_one_target" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.3"
  count                  = var.single_target_group ? 1 : 0
  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = data.aws_lb_listener.api.arn
  listener_rule_priority = var.listener_rule_priority + var.listener_rule_priority_interval
  host_header_values = [
    "${var.subdomain_api}.${local.dns_zone}",
    "${var.subdomain_eat}.${local.dns_zone}",
    "${var.subdomain_ordering}.${local.dns_zone}",
    "${var.subdomain_facebook}.${local.dns_zone}"
  ]
  service           = var.service
  target_group_arns = [local.api_target_group_arn]
}
