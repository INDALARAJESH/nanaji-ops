# ALB with fixed response:
module "admin_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.8"

  certificate_arn            = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_cloudflare = "admin-cf"
  cname_subdomain_alb        = "admin-origin"
  env                        = var.env
  name_prefix                = "admin"
  service                    = var.service
  vpc_id                     = data.aws_vpc.selected.id

  security_group_ids = [
    data.aws_security_group.vpn_web.id,
    data.aws_security_group.ingress_cloudflare.id,
    data.aws_security_group.internal_env.id,
  ]
}

# ALB with forwarding and target group:
module "admin_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.7"

  alb_listener_da_type = "forward"
  certificate_arn      = data.aws_acm_certificate.star_chownow.arn
  env                  = var.env
  name_prefix          = "admin"
  service              = var.service
  vpc_id               = data.aws_vpc.selected.id

  enable_gdpr_cname_cloudflare = 1

  security_group_ids   = [
    aws_security_group.vpn.id
    ]
}
