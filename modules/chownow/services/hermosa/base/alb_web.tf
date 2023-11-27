###########
# Web ALB #
###########
module "web_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.6"
  count  = var.enable_alb_web

  certificate_arn               = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_alb           = var.enable_cloudflare == 1 ? var.web_cname_alb : "web"
  enable_gdpr_cname_cloudflare  = var.enable_gdpr_cname_cloudflare
  enable_http_to_https_redirect = var.enable_http_to_https_redirect
  enable_geolocation            = 1
  env                           = var.env
  env_inst                      = var.env_inst
  name_prefix                   = "web"
  service                       = var.service
  vpc_id                        = data.aws_vpc.selected.id

  security_group_ids = [
    data.aws_security_group.ingress_cloudflare.id,
    module.vpn_sg.id,
    module.vpn_web_sg.id,
    module.internal_sg.id,
  ]
}


#######################################
# Web Target Group and Listener Rules #
#######################################
module "web_hermosa_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.0"

  count = var.enable_alb_web

  alb_name            = module.web_hermosa_alb[0].alb_name
  env                 = var.env
  env_inst            = var.env_inst
  health_check_target = var.web_healthcheck_target
  service             = var.service
  vpc_id              = data.aws_vpc.selected.id
}

# This rule is necessary because the path `/admin` should be served by the admin instances.
# The rule redirects to admin.chownow.com (or admin.ENV.svpn.chownow.com)
module "web_listener_rule_admin_redirect" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_web

  env                       = var.env
  env_inst                  = var.env_inst
  listener_arn              = module.web_hermosa_alb[0].listener_arn
  listener_rule_action_type = "redirect"
  listener_rule_priority    = 15
  redirect_host             = "admin.${local.dns_zone}"
  redirect_path_destination = var.ar_path_destination
  redirect_path_origin      = ["/admin*"]
  redirect_query            = var.ar_query
  service                   = var.service
  target_group_arn          = var.ar_target_group_arn
}

# Api subdomain listener rule to forward requests based on host header
module "web_listener_rule_api" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_web

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.web_hermosa_alb[0].listener_arn
  listener_rule_priority = 40
  host_header_values     = ["${var.subdomain_api}.${local.dns_zone}"]
  service                = var.service
  target_group_arn       = module.web_hermosa_tg[0].tg_arn
}

# Creates CNAME to forward api subdomain requests to Cloudflare
module "cname_cloudflare_api" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  count = var.enable_alb_web == 1 && var.enable_cloudflare == 1 ? 1 : 0

  name    = "${var.subdomain_api}.${local.dns_zone}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = var.ttl_api
  type    = "CNAME"
  records = ["${var.subdomain_api}.${local.dns_zone}.${var.cloudflare_domain}"]
}

# Creates CNAME to forward api subdomain requests to alb
module "cname_api" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  count = var.enable_alb_web == 1 && var.enable_cloudflare == 0 ? 1 : 0

  name    = "${var.subdomain_api}.${local.dns_zone}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = var.ttl_api
  type    = "CNAME"
  records = [module.web_hermosa_alb[count.index].alb_dns_name]
}

# Eat subdomain listener rule to forward requests based on host header
module "web_listener_rule_eat" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_eat == 1 && var.enable_alb_web == 1 ? 1 : 0

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.web_hermosa_alb[0].listener_arn
  listener_rule_priority = 50
  host_header_values     = ["${var.subdomain_eat}.${local.dns_zone}"]
  service                = var.service
  target_group_arn       = module.web_hermosa_tg[0].tg_arn
}

# Creates CNAME to forward eat subdomain requests to Cloudflare
module "cname_cloudflare_eat" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  count = var.enable_eat == 1 && var.enable_alb_web == 1 && var.enable_cloudflare == 1 ? 1 : 0

  name    = "${var.subdomain_eat}.${local.dns_zone}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = var.ttl_eat
  type    = "CNAME"
  records = ["${var.subdomain_eat}.${local.dns_zone}.${var.cloudflare_domain}"]

  enable_gdpr_cname = var.enable_gdpr_cname_eat
}

# Ordering subdomain listener rule to forward requests based on host header
module "web_listener_rule_ordering" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_web

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.web_hermosa_alb[0].listener_arn
  listener_rule_priority = 60
  host_header_values     = ["${var.subdomain_ordering}.${local.dns_zone}"]
  service                = var.service
  target_group_arn       = module.web_hermosa_tg[0].tg_arn
}

# Creates CNAME to forward ordering subdomain requests to Cloudflare
module "cname_cloudflare_ordering" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  count = var.enable_alb_web == 1 && var.enable_cloudflare == 1 ? 1 : 0

  name    = "${var.subdomain_ordering}.${local.dns_zone}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = var.ttl_ordering
  type    = "CNAME"
  records = ["${var.subdomain_ordering}.${local.dns_zone}.${var.cloudflare_domain}"]

  enable_gdpr_cname = var.enable_gdpr_cname_ordering
}

# Creates CNAME to forward ordering subdomain requests to alb
module "cname_ordering" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  count = var.enable_alb_web == 1 && var.enable_cloudflare == 0 ? 1 : 0

  name    = "${var.subdomain_ordering}.${local.dns_zone}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = var.ttl_api
  type    = "CNAME"
  records = [module.web_hermosa_alb[count.index].alb_dns_name]
}

# Facebook subdomain listener rule to forward requests based on host header
module "web_listener_rule_facebook" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  count = var.enable_alb_web

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.web_hermosa_alb[0].listener_arn
  listener_rule_priority = 90
  host_header_values     = ["${var.subdomain_facebook}.${local.dns_zone}"]
  service                = var.service
  target_group_arn       = module.web_hermosa_tg[0].tg_arn
}

# Creates 2 CNAMEs, one for forwarding on requests to cloudflare,
# the other to redirect EU users to the GDPR cloudfront distribution
module "cname_cloudflare_facebook" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  count = var.enable_alb_web == 1 && var.enable_cloudflare == 1 ? 1 : 0

  name    = "${var.subdomain_facebook}.${local.dns_zone}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = var.ttl_facebook
  type    = "CNAME"
  records = ["${var.subdomain_facebook}.${local.dns_zone}.${var.cloudflare_domain}"]

  enable_gdpr_cname = var.enable_gdpr_cname_facebook
}
