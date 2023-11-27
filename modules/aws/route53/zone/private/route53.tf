resource "aws_route53_zone" "private" {
  count   = var.enable_zone == "1" ? 1 : 0
  name    = var.domain_name
  comment = var.description

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"    = var.domain_name,
      "DNSType" = "private",
    }
  )
}

output "zone_id" {
  value = length(aws_route53_zone.private.*.zone_id) < 1 ? "" : join(",", aws_route53_zone.private.*.zone_id)
}
