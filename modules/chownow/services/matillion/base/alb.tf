########################
# Public Matillion ALB #
########################

module "public_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.0"

  alb_log_bucket      = "not-provisioned-yet"
  access_logs_enabled = false
  certificate_arn     = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_alb = var.service # matillion.ENV.svpn.chownow.com
  env                 = var.env
  service             = var.service
  vpc_id              = data.aws_vpc.selected.id

  security_group_ids = [aws_security_group.alb_public.id]
}


# Target group for Matillion instance(s) and responds on TCP 80
module "public_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.0"

  alb_name              = module.public_alb.alb_name
  alb_listener_protocol = "HTTP"
  env                   = var.env
  env_inst              = var.env_inst
  tg_port               = 80
  health_check_target   = var.public_tg_hc_target
  service               = var.service
  vpc_id                = data.aws_vpc.selected.id
}

# Listener rule which matches on the host header matillion.ENV.svpn.chownow.com from
# TCP 443 and forwards them to the above target group on TCP 80
module "public_listener_rule_default" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.public_alb.listener_arn
  listener_rule_priority = 10
  host_header_values     = ["${var.service}.${local.dns_zone}"]
  service                = var.service
  target_group_arn       = module.public_tg.tg_arn

  depends_on = [module.public_alb.listener_arn, module.public_tg.tg_arn]

}
