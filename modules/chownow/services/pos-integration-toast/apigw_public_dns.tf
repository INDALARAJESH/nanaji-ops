locals {
  # records for mapping environments to cname slugs because ncp doesnt have a real one
  cloudflare_cname_slugs = {
    "ncp" = "chownowapi.com"
    "qa"  = "qa.chownowapi.com"
    "stg" = "stg.chownowapi.com"
    "uat" = "uat.chownowapi.com"
    "dev" = "dev.chownowapi.com"
  }
}

# Connects a custom domain name registered via aws_api_gateway_domain_name with a deployed API so that its methods can be called via the custom domain name.
resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.webhook_api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = aws_api_gateway_domain_name.this_public.domain_name
}

resource "aws_api_gateway_domain_name" "this_public" {
  domain_name              = local.env == "ncp" ? "pos-toast.chownowapi.com" : "pos-toast.${local.env}.chownowapi.com"
  regional_certificate_arn = data.aws_acm_certificate.cert.arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# cname the public record to cloudflare, where a proxy record exists back to -origin
resource "aws_route53_record" "authority_to_cloudflare" {
  zone_id = data.aws_route53_zone.chownowapi.zone_id
  name    = "pos-toast.${local.cloudflare_cname_slugs[local.env]}"
  type    = "CNAME"
  ttl     = 60
  records = ["pos-toast.${local.cloudflare_cname_slugs[local.env]}.cdn.cloudflare.net"]
}

# cname -origin to the backing resource. in this case, the alb's cname
resource "aws_route53_record" "origin_to_endpoint" {
  zone_id = data.aws_route53_zone.chownowapi.zone_id
  name    = "pos-toast-origin.${local.cloudflare_cname_slugs[local.env]}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_api_gateway_domain_name.this_public.regional_domain_name]
}
