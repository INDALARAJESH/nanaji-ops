module "hermosa_base" {
  source                  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/base?ref={{cookiecutter.base_module_ref}}"
  env                     = var.env
  env_inst                = var.env_inst
  custom_vpc_name         = "${var.env}${var.env_inst}"
  enable_alb_admin        = 1
  enable_alb_web          = 1
  enable_cloudflare       = 1
  enable_alb_webhookproxy = 1
  enable_vpce             = 0
  web_cname_alb           = "api-origin"
  # VPN, jenkins, jenkins node NAT GW, load tests uatload NAT GW
  vpn_subnets                   = ["54.183.225.53/32", "54.183.68.210/32", "52.21.177.104/32", "34.224.187.148/32", "34.192.190.3/32"]
  cdn_cnames                    = ["{{cookiecutter.static_assets_cdn_cname}}"]
  subdomain_webhookproxy_origin = "webhookproxy-origin"
  subdomain_webhookproxy        = "webhookproxy"
}
