# REST API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = var.name

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", var.name,
    )
  )
}

# Custom domains
resource "aws_api_gateway_domain_name" "api" {
  domain_name     = "${var.subdomain}.${var.domain}"
  certificate_arn = data.aws_acm_certificate.cert.arn
  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", "${var.subdomain}.${var.domain}",
    )
  )
}

resource "aws_api_gateway_domain_name" "origin" {
  domain_name     = "${var.subdomain}-origin.${var.domain}"
  certificate_arn = data.aws_acm_certificate.cert.arn
  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", "${var.subdomain}-origin.${var.domain}",
    )
  )
}

# Route53 record
resource "aws_route53_record" "api" {
  name    = "${var.subdomain}-origin"
  type    = "A"
  zone_id = data.aws_route53_zone.api.zone_id

  alias {
    name                   = aws_api_gateway_domain_name.origin.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.origin.cloudfront_zone_id
    evaluate_target_health = false
  }
}
