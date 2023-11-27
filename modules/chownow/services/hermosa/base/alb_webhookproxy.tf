###########
# Webhookproxy ALB #
###########
module "webhookproxy_web_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"
  count  = var.enable_alb_webhookproxy

  custom_sg_name = "web-${var.env}${var.env_inst}"
  description    = "Allow web connections from the internet"
  env            = var.env
  env_inst       = var.env_inst
  service        = var.service
  name_prefix    = "web"
  vpc_id         = data.aws_vpc.selected.id

  ingress_tcp_allowed = ["443"]
  cidr_blocks         = ["0.0.0.0/0"]
}

module "webhookproxy_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.6"
  count  = var.enable_alb_webhookproxy

  certificate_arn               = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_alb           = var.subdomain_webhookproxy
  enable_gdpr_cname_cloudflare  = var.enable_gdpr_cname_cloudflare
  enable_http_to_https_redirect = var.enable_http_to_https_redirect
  enable_geolocation            = 0
  env                           = var.env
  env_inst                      = var.env_inst
  name_prefix                   = ""
  service                       = "webhookproxy"
  vpc_id                        = data.aws_vpc.selected.id

  security_group_ids = [
    module.webhookproxy_web_sg[count.index].id
  ]
}
