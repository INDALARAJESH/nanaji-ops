resource "cloudflare_record" "origin" {
  count   = length(var.subdomains)
  zone_id = data.cloudflare_zone.chownow.id
  name    = "${var.subdomains[count.index]}.${local.env}.${var.domain}"
  value   = "${var.subdomains[count.index]}-origin.${local.env}.${var.domain}"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "ordering_origin" {
  zone_id = data.cloudflare_zone.chownow.id
  name    = "ordering.${local.env}.${var.domain}"
  value   = "api-origin.${local.env}.${var.domain}"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}
