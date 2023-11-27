## Route53
resource "aws_route53_record" "app_dns" {
  count   = length(var.app_domains)
  name    = element(var.app_domains, count.index)
  zone_id = data.aws_route53_zone.svpn.id
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
