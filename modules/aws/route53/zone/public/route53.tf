resource "aws_route53_zone" "public" {
  count = var.enable_zone == "1" ? 1 : 0

  name    = var.domain_name
  comment = var.description

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"    = var.domain_name,
      "DNSType" = "public",
    }
  )
}

output "zone_id" {
  value = length(aws_route53_zone.public.*.zone_id) < 1 ? "" : join(",", aws_route53_zone.public.*.zone_id)
}

output "name_servers" {
  value = flatten(aws_route53_zone.public.0.name_servers)
}
