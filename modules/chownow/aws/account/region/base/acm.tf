# Wildcard certificate creation for {ENV}.svpn.chownow.com (without environment instance)
module "wildcard" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/acm/wildcard?ref=aws-acm-wildcard-v2.0.0"

  count = var.enable_cert_wildcard

  env           = var.env
  env_inst      = var.env_inst
  dns_zone_name = local.dns_zone

  extra_tags = local.extra_tags

}

module "chownowapi" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/acm/wildcard?ref=aws-acm-wildcard-v2.0.0"

  count = var.enable_cert_chownowapi

  env           = var.env
  env_inst      = var.env_inst
  dns_zone_name = local.dns_zone_chownowapi

  extra_tags = local.extra_tags

}

module "chownowcdn" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/acm/wildcard?ref=aws-acm-wildcard-v2.0.0"

  count = var.enable_cert_chownowcdn

  env           = var.env
  env_inst      = var.env_inst
  dns_zone_name = local.dns_zone_chownowcdn

  extra_tags = local.extra_tags

}
