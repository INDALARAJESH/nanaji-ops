resource "aws_route53_record" "authority_to_cloudflare" {
  zone_id = data.aws_route53_zone.api.zone_id
  name    = local.service_domain_name
  type    = "CNAME"
  ttl     = 60
  records = ["${local.service_domain_name}.cdn.cloudflare.net"]
}

resource "aws_route53_record" "origin_to_endpoint" {
  zone_id = data.aws_route53_zone.api.zone_id
  name    = local.service_origin_domain_name
  type    = "CNAME"
  ttl     = 60
  records = [aws_api_gateway_domain_name.this_public.regional_domain_name]
}

resource "aws_api_gateway_domain_name" "this_public" {
  domain_name              = local.service_domain_name
  regional_certificate_arn = data.aws_acm_certificate.cert.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
