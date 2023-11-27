module "cname" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"
  count   = var.enable_alb
  name    = "${local.default_subdomain}.${local.dns_domain}"
  zone_id = data.aws_route53_zone.public.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.alb_public[0].alb_dns_name}."]
}

module "cname_additionals" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"
  count   = var.enable_alb == 1 ? length(var.subdomains) : 0
  name    = "${var.subdomains[count.index]}.${local.dns_domain}"
  zone_id = data.aws_route53_zone.public.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["${local.default_subdomain}.${local.dns_domain}."]
}

module "cname_blue" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"
  count   = var.enable_canary
  name    = "${local.service}-blue.${local.env}.${var.domain_public}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = "300"
  type    = "CNAME"
  records = ["${data.aws_lb.public.dns_name}"]
}

module "cname_green" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"
  count   = var.enable_canary
  name    = "${local.service}-green.${local.env}.${var.domain_public}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = "300"
  type    = "CNAME"
  records = ["${data.aws_lb.public.dns_name}"]
}
