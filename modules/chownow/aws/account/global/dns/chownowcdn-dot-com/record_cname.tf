module "r53_emailbuilderimages_ncp" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"
  zone_id = data.aws_route53_zone.chownowcdn_dot_com.zone_id
  name    = "emailbuilder.chownowcdn.com"
  type    = "CNAME"
  records = [
    "emailbuilder.chownowcdn.com.cdn.cloudflare.net"
  ]
}

module "r53_menuimages_ncp" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"
  zone_id = data.aws_route53_zone.chownowcdn_dot_com.zone_id
  name    = "menuimages.chownowcdn.com"
  type    = "CNAME"
  records = [
    "menuimages.chownowcdn.com.cdn.cloudflare.net"
  ]
}
