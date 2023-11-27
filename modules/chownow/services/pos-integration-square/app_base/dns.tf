# amazon side, direct public DNS queries to the cloudflare proxy record
resource "aws_route53_record" "authority_to_cloudflare" {
  zone_id = data.aws_route53_zone.api.zone_id
  name    = var.env == "ncp" ? "pos-square.chownowapi.com" : "pos-square.${local.env}.chownowapi.com"
  type    = "CNAME"
  ttl     = 60
  records = [var.env == "ncp" ? "pos-square.chownowapi.com.cdn.cloudflare.net" : "pos-square.${local.env}.chownowapi.com.cdn.cloudflare.net"]
}

# we need to figure out cloudflare records first and confirm a safe apply,
# afterwards, this should exist here.
# resource "cloudflare_record" "cloudflare_to_origin" {
#     zone_id = # todo
#     name = "pos-square-origin.${local.env}.chownowapi.com"
#     type = "CNAME"
#     ttl = 1 # "automatic"
#     proxied = true # "orange cloud"
#     allow_overwrite = false # we never want this on
# }

# amazon side, CNAME an -origin record to the backing resource
resource "aws_route53_record" "origin_to_endpoint" {
  zone_id = data.aws_route53_zone.api.zone_id
  name    = var.env == "ncp" ? "pos-square-origin.chownowapi.com" : "pos-square-origin.${local.env}.chownowapi.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_api_gateway_domain_name.this_public-origin.regional_domain_name]
}

# resource "aws_api_gateway_domain_name" "this_public" {
#   domain_name              = "pos-square.${local.env}.chownowapi.com"
#   regional_certificate_arn = data.aws_acm_certificate.cert.arn

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }

#   tags = merge(
#     local.common_tags,
#     local.extra_tags
#   )
# }

resource "aws_api_gateway_domain_name" "this_public-origin" {
  domain_name              = var.env == "ncp" ? "pos-square-origin.chownowapi.com" : "pos-square-origin.${local.env}.chownowapi.com"
  regional_certificate_arn = data.aws_acm_certificate.cert.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    local.common_tags,
    local.extra_tags
  )
}
