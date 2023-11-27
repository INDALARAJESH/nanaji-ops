## Route53
resource "aws_route53_record" "app_dns" {
  count   = length(var.app_domains)
  name    = element(var.app_domains, count.index)
  zone_id = (var.overwrite_zone_ids != "") ? element(var.overwrite_zone_ids, count.index) : data.aws_route53_zone.svpn.id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.app_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.app_distribution.hosted_zone_id
    evaluate_target_health = false
  }

  geolocation_routing_policy {
    country = "*"
  }

  set_identifier = "Default"
}

# Additional CNAME record option to create routing policy for clients from the EU per GDPR compliance
resource "aws_route53_record" "app_dns_eu" {
  count   = length(var.app_domains)
  name    = element(var.app_domains, count.index)
  zone_id = (var.overwrite_zone_ids != "") ? element(var.overwrite_zone_ids, count.index) : data.aws_route53_zone.svpn.id
  type    = "A"

  alias {
    name                   = var.gdpr_destination
    zone_id                = aws_cloudfront_distribution.app_distribution.hosted_zone_id
    evaluate_target_health = false
  }

  geolocation_routing_policy {
    continent = var.gdpr_geo_continent
  }

  set_identifier = var.gdpr_geo_continent
}
