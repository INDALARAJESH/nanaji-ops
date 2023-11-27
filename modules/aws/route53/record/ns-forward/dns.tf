resource "aws_route53_record" "environment_nameservers" {

  name    = var.subdomain != "" ? "${local.env}.${var.subdomain}.${var.domain}" : "${local.env}.${var.domain}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.forwarder.zone_id

  records = var.nameservers
}
