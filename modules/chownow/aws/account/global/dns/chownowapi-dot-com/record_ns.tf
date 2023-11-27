resource "aws_route53_record" "nameservers" {

  name    = "${local.env}.${var.domain}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownowapi.zone_id
  records = data.aws_route53_zone.delegate_chownowapi.name_servers
}

