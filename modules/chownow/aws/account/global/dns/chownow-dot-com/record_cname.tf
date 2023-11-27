## OPS-2500 ##

module "cname_dam_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "dam.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "chownow.bynder.com."
  ]
}

module "cname_dam_acm_validation" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "_ce489e6f79f72327f5e9974f07748148.dam.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "_fe6a84c2b57e9748449cfc574f010862.cvfdyspdbk.acm-validations.aws."
  ]
}

module "pos_service_route53_to_cloudflare" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"
  name    = "pos-service.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "pos-square.chownow.com.cdn.cloudflare.net"
  ]
}

module "cname_stories_chownow_com" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"
  name    = "stories.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "cnstories.wpengine.com"
  ]
}

module "cname_groove_chownow_com" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"
  name    = "groove.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "branded.groove.co"
  ]
}

module "pritunl_chownow_cdn_cloudflare" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"
  name    = "pritunl.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "pritunl.chownow.com.cdn.cloudflare.net"
  ]
}

### OPS-4688 ###

module "cname_r_chownow_com_twilio" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"
  name    = "r.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "lsct.ashburn.us1.twilio.com"
  ]
}

### OPS-4808 ###

module "cname_patnerstack_chownow_com_em" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"
  name    = "em7894.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "u1741745.wl246.sendgrid.net"
  ]
}

module "cname_patnerstack_chownow_com_ps" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"
  name    = "ps._domainkey.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "ps.domainkey.u1741745.wl246.sendgrid.net"
  ]
}

module "cname_patnerstack_chownow_com_ps2" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"
  name    = "ps2._domainkey.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CNAME"
  records = [
    "ps2.domainkey.u1741745.wl246.sendgrid.net"
  ]
}
