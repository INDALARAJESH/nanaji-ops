resource "aws_route53_record" "a" {
  count = var.type == "A" && var.enable_record == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records

  geolocation_routing_policy {
    country = var.geo_country
  }

  set_identifier = var.geo_identifier
}

resource "aws_route53_record" "caa" {
  count = var.type == "CAA" && var.enable_record == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records

  geolocation_routing_policy {
    country = var.geo_country
  }

  set_identifier = var.geo_identifier
}

resource "aws_route53_record" "cname" {
  count = var.type == "CNAME" && var.enable_record == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records

  geolocation_routing_policy {
    country = var.geo_country
  }

  set_identifier = var.geo_identifier
}

# Additional CNAME record option to create routing policy for clients from the EU per GDPR compliance
resource "aws_route53_record" "cname_gdpr" {
  count = var.type == "CNAME" && var.enable_gdpr_cname == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = ["${var.gdpr_destination}."]
  geolocation_routing_policy {
    continent = var.gdpr_geo_continent
  }

  set_identifier = var.gdpr_geo_identifier
}

resource "aws_route53_record" "mx" {
  count = var.type == "MX" && var.enable_record == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records

  geolocation_routing_policy {
    country = var.geo_country
  }

  set_identifier = var.geo_identifier
}

resource "aws_route53_record" "ptr" {
  count = var.type == "PTR" && var.enable_record == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records

  geolocation_routing_policy {
    country = var.geo_country
  }

  set_identifier = var.geo_identifier
}

resource "aws_route53_record" "spf" {
  count = var.type == "SPF" && var.enable_record == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records

  geolocation_routing_policy {
    country = var.geo_country
  }

  set_identifier = var.geo_identifier
}

resource "aws_route53_record" "srv" {
  count = var.type == "SRV" && var.enable_record == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records

  geolocation_routing_policy {
    country = var.geo_country
  }

  set_identifier = var.geo_identifier
}

resource "aws_route53_record" "txt" {
  count = var.type == "TXT" && var.enable_record == 1 ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records

  geolocation_routing_policy {
    country = var.geo_country
  }

  set_identifier = var.geo_identifier
}
