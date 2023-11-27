resource "aws_route53_zone" "chowqa" {
  name = var.dns_zone
  tags = local.common_tags

}


resource "aws_route53_record" "chowqa" {
  for_each = var.dns_records

  zone_id = aws_route53_zone.chowqa.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}

output "nameservers" {
  value = aws_route53_zone.chowqa.name_servers
}
