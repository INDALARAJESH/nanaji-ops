module "cname_cloudflare_channels" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  name    = "${var.subdomain_name}."
  records = ["${var.subdomain_name}.${var.domain_name}.${var.cloudflare_domain}"]
  ttl     = "300"
  type    = "CNAME"
  zone_id = data.aws_route53_zone.api.zone_id

  enable_gdpr_cname = 1
}
