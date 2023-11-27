resource "aws_route53_record" "pritunl_vpn" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "pritunl-vpn.${local.dns_zone}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.pritunl_public.dns_name]
}

resource "aws_route53_record" "pritunl_origin_cloudflare" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "pritunl-origin.${local.dns_zone}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.pritunl_public.dns_name]
}

