###########
# Ops ALB #
###########
module "ops_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=cn-ops-base-v3.0.0&depth=1"

  certificate_arn                = data.aws_acm_certificate.svpn.arn
  cname_subdomain_alb            = "${var.service}-origin"
  enable_gdpr_cname_cloudflare   = 0
  enable_http_to_https_redirect  = 0
  enable_geolocation             = 0
  env                            = var.env
  env_inst                       = var.env_inst
  name_prefix                    = ""
  service                        = var.service
  vpc_id                         = data.aws_vpc.selected.id
  alb_name                       = "ops-alb-${local.env}"
  security_group_name            = "default-vpn-web-${local.env}"
  access_logs_enabled            = false
  listener_da_fixed_status_code  = 200
  listener_da_fixed_message_body = "c h o w n o w"
  security_group_ids = [
    data.aws_security_group.ingress_cloudflare.id,
    data.aws_security_group.internal.id,
    data.aws_security_group.ops.id,
  ]
}
