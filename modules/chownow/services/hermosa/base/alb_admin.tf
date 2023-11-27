#############
# Admin ALB #
#############
#
# When enabling cloudflare: admin_cname_cloudflare.ENV.svpn.chownow.com => admin_cname_alb.ENV.cdn.cloudflare.net = points to => admin_cname_alb = points to => alb
#                           admin.ENV.svpn.chownow.com => admin.ENV.cdn.cloudflare.net => admin-origin.ENV.svpn.chownow.com => alb
#
module "admin_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.6"

  count = var.enable_alb_admin

  certificate_arn               = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_cloudflare    = var.enable_cloudflare == 1 ? var.admin_cname_cloudflare : ""
  cname_subdomain_alb           = var.enable_cloudflare == 1 ? var.admin_cname_alb : "admin"
  enable_gdpr_cname_cloudflare  = var.enable_gdpr_cname_cloudflare
  enable_http_to_https_redirect = var.enable_http_to_https_redirect
  enable_geolocation            = 1
  env                           = var.env
  env_inst                      = var.env_inst
  name_prefix                   = "admin"
  service                       = var.service
  vpc_id                        = data.aws_vpc.selected.id

  security_group_ids = [
    data.aws_security_group.ingress_cloudflare.id,
    module.vpn_sg.id,
    module.vpn_web_sg.id,
    module.internal_sg.id,
  ]

}

#########################################
# Admin Target Group and Listener Rules #
#########################################
module "admin_hermosa_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.0"

  count = var.enable_alb_admin

  alb_name            = module.admin_hermosa_alb[0].alb_name
  env                 = var.env
  env_inst            = var.env_inst
  health_check_target = var.admin_healthcheck_target
  service             = var.service
  vpc_id              = data.aws_vpc.selected.id
}

# Allows access to admin paths
module "admin_listener_rule_admin" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_admin

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.admin_hermosa_alb[0].listener_arn
  listener_rule_priority = 50
  path_pattern_values    = ["/admin*"]
  service                = var.service
  target_group_arn       = module.admin_hermosa_tg[0].tg_arn
}

# Allows static assets to load through ALB
module "admin_listener_rule_static" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_admin

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.admin_hermosa_alb[0].listener_arn
  listener_rule_priority = 60
  path_pattern_values    = ["/static*"]
  service                = var.service
  target_group_arn       = module.admin_hermosa_tg[0].tg_arn
}

# Necessary for favicon.ico to display :/
module "admin_listener_rule_favicon" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_admin

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.admin_hermosa_alb[0].listener_arn
  listener_rule_priority = 65
  path_pattern_values    = ["/favicon.ico"]
  service                = var.service
  target_group_arn       = module.admin_hermosa_tg[0].tg_arn
}

# Allows api path to be served by admin ec2 instances
module "admin_listener_rule_api" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_admin

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.admin_hermosa_alb[0].listener_arn
  listener_rule_priority = 70
  path_pattern_values    = ["/api*"]
  service                = var.service
  target_group_arn       = module.admin_hermosa_tg[0].tg_arn
}

# Necessary for `Reset Password` button on admin login page
module "admin_listener_rule_forgot" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_admin

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.admin_hermosa_alb[0].listener_arn
  listener_rule_priority = 75
  path_pattern_values    = ["/forgot*"]
  service                = var.service
  target_group_arn       = module.admin_hermosa_tg[0].tg_arn
}

# redirects base path to /admin/login
module "admin_listener_rule_redirect" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_admin

  env                       = var.env
  env_inst                  = var.env_inst
  listener_arn              = module.admin_hermosa_alb[0].listener_arn
  listener_rule_action_type = "redirect"
  listener_rule_priority    = 80
  redirect_path_origin      = ["/"]
  redirect_path_destination = "/admin/login"
  service                   = var.service
  target_group_arn          = "null"
}

#######################################################
# Admin Cloud Kitchens Target Group and Listener Rule #
#######################################################
module "admin_hermosa_tg_ck" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.0"

  count = var.enable_alb_admin

  alb_name            = module.admin_hermosa_alb[0].alb_name
  env                 = var.env
  env_inst            = var.env_inst
  health_check_target = var.admin_healthcheck_target
  name_suffix         = "ck"
  service             = var.service
  vpc_id              = data.aws_vpc.selected.id
}

# Routes all "cloudkitchen" user agent requests to cloudkitchens admin instances
module "admin_listener_rule_ck" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_admin

  env                    = var.env
  env_inst               = var.env_inst
  http_header_values     = var.isolated_useragents
  listener_arn           = module.admin_hermosa_alb[0].listener_arn
  listener_rule_priority = var.admin_listener_rule_priority
  service                = var.service
  target_group_arn       = module.admin_hermosa_tg_ck[0].tg_arn
}
