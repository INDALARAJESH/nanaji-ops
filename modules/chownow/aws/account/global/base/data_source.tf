data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "public" {
  count        = var.enable_zone_svpn_public == 0 && var.enable_record_caa == 1 ? 1 : 0
  name         = "${local.public_svpn_domain}."
  private_zone = false
}

data "aws_route53_zone" "chownowcdn" {
  count        = var.enable_zone_chownowcdn == 0 && var.enable_record_caa_chownowcdn == 1 ? 1 : 0
  name         = "${local.chownowcdn_domain}."
  private_zone = false
}

data "aws_route53_zone" "chownowapi" {
  count        = var.enable_zone_chownowapi == 0 && var.enable_record_caa_chownowapi == 1 ? 1 : 0
  name         = "${local.chownowapi_domain}."
  private_zone = false
}
