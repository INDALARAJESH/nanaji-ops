resource "aws_route53_record" "ec2_private" {
  count = var.enable_dns_record_private == 1 && local.env != "prod" ? var.instance_count : 0

  name    = format("%s%d.%s", local.instance_name, count.index, local.dns_zone_private)
  ttl     = var.dns_ttl
  type    = var.dns_type
  records = [aws_instance.vm.*.private_ip[count.index]]
  zone_id = data.aws_route53_zone.private.0.zone_id
}


resource "aws_route53_record" "ec2_public" {
  count = var.enable_dns_record_public == 1 && local.env != "prod" ? var.instance_count : 0

  name    = format("%s%d.%s", local.instance_name, count.index, local.dns_zone_public)
  ttl     = var.dns_ttl
  type    = var.dns_type
  records = [aws_instance.vm.*.private_ip[count.index]]
  zone_id = data.aws_route53_zone.public.0.zone_id
}

resource "aws_route53_record" "public_ip" {
  count = var.associate_public_ip_address && local.env != "prod" ? var.instance_count : 0

  name    = format("%s%d.%s", local.instance_name, count.index, local.dns_zone_public)
  ttl     = var.dns_ttl
  type    = var.dns_type
  records = [aws_instance.vm.*.public_ip[count.index]]
  zone_id = data.aws_route53_zone.public.0.zone_id
}
