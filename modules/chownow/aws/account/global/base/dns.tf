### Public SVPN zone eg {ENV}.svpn.chownow.com (for lower envs)
module "chownow_public_svpn_zone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/zone/public?ref=aws-r53-zone-public-v2.0.0"

  count = var.enable_zone_svpn_public

  description = "public dns zone for ${local.public_svpn_domain}"
  domain_name = local.public_svpn_domain
}

### Necessary for cert creation/validation
module "caa" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"

  count = var.enable_record_caa == 1 && var.enable_zone_svpn_public == 1 ? 1 : 0

  records = var.caa_records
  type    = var.caa_type
  zone_id = module.chownow_public_svpn_zone.0.zone_id
}

# when svpn zone creation is skipped, a data source lookup is performed to create the record
module "caa_alt" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"

  count = var.enable_record_caa == 1 && var.enable_zone_svpn_public == 0 ? 1 : 0

  records = var.caa_records
  type    = var.caa_type
  zone_id = join(",", data.aws_route53_zone.public.*.zone_id)
}

### Public chownowcdn zone eg {ENV}.chownowcdn.com (for lower envs)
module "chownowcdn_zone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/zone/public?ref=aws-r53-zone-public-v2.0.0"

  count = var.enable_zone_chownowcdn

  description = "public dns zone for ${local.chownowcdn_domain}"
  domain_name = local.chownowcdn_domain
}

### Necessary for cert creation/validation
module "caa_chownowcdn" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"

  count = var.enable_record_caa_chownowcdn == 1 && var.enable_zone_chownowcdn == 1 ? 1 : 0

  records = var.caa_records
  type    = var.caa_type
  zone_id = module.chownowcdn_zone.0.zone_id
}

# when chownowcdn zone creation is skipped, a data source lookup is performed to create the record
module "caa_chownowcdn_alt" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"

  count = var.enable_record_caa_chownowcdn == 1 && var.enable_zone_chownowcdn == 0 ? 1 : 0

  records = var.caa_records
  type    = var.caa_type
  zone_id = join(",", data.aws_route53_zone.chownowcdn.*.zone_id)
}

### Public chownowapi zone eg {ENV}.chownowapi.com (for lower envs)
module "chownowapi_zone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/zone/public?ref=aws-r53-zone-public-v2.0.0"

  count = var.enable_zone_chownowapi

  description = "public dns zone for ${local.chownowapi_domain}"
  domain_name = local.chownowapi_domain
}

### Necessary for cert creation/validation
module "caa_chownowapi" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"

  count = var.enable_record_caa_chownowapi == 1 && var.enable_zone_chownowapi == 1 ? 1 : 0

  records = var.caa_records
  type    = var.caa_type
  zone_id = module.chownowapi_zone.0.zone_id
}

# when chownowapi zone creation is skipped, a data source lookup is performed to create the record
module "caa_chownowapi_alt" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"

  count = var.enable_record_caa_chownowapi == 1 && var.enable_zone_chownowapi == 0 ? 1 : 0

  records = var.caa_records
  type    = var.caa_type
  zone_id = join(",", data.aws_route53_zone.chownowapi.*.zone_id)
}
