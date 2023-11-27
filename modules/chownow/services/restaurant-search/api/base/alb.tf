module "restaurant_search_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.4"

  certificate_arn     = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_alb = "search"
  env                 = var.env
  env_inst            = var.env_inst
  service             = var.service
  vpc_id              = data.aws_vpc.private.id
  tg_port             = local.container_port
  tg_protocol         = "HTTP"
  tg_target_type      = "ip"
  health_check_target = "/health"

  enable_gdpr_cname_cloudflare  = 1
  enable_http_to_https_redirect = 1

  security_group_ids = [module.ingress_vpn_sg.id]
}

module "ingress_vpn_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description = "security group to allow incoming connections from vpn"
  env         = var.env
  env_inst    = var.env_inst
  name_prefix = var.service
  service     = var.service
  vpc_id      = data.aws_vpc.private.id

  ingress_tcp_allowed = ["443", "80"]
  cidr_blocks         = concat(data.aws_ec2_managed_prefix_list.pritunl_public_ips.entries[*].cidr, var.allowed_ip_addresses)
}

module "restaurant_search_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"

  alb_name              = module.restaurant_search_alb.alb_name
  env                   = var.env
  env_inst              = var.env_inst
  target_group_name     = "${var.service}-${local.env}-api-tg"
  service               = var.service
  vpc_id                = data.aws_vpc.private.id
  tg_port               = local.container_port
  alb_listener_protocol = "HTTP"
  health_check_target   = "/health"
  health_check_interval = 10
  alb_tg_target_type    = "ip"
}

module "api_listener_rule" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.1"

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.restaurant_search_alb.listener_arn
  listener_rule_priority = 50
  path_pattern_values    = ["/*"]
  service                = var.service
  target_group_arns      = [module.restaurant_search_tg.tg_arn]
}
