resource "aws_route53_zone" "private" {
  count = var.enable_zone_private == 1 ? 1 : 0

  comment = "${local.vpc_name} VPC private aws zone"
  name    = "${local.env}.aws.${var.domain}"

  vpc {
    vpc_id = aws_vpc.mod.id
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.env}.aws.${var.domain}" }
  )
}

resource "aws_route53_record" "caa" {
  count = var.enable_zone_private == 1 ? 1 : 0

  name    = "CAA"
  records = var.caa_records
  type    = "CAA"
  ttl     = "300"
  zone_id = aws_route53_zone.private[0].zone_id
}
