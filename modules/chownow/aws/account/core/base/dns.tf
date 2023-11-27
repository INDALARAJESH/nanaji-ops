resource "aws_route53_zone" "env_private" {
  count = var.enable_vpc_env

  comment = "${local.env} VPC private aws zone"
  name    = "${local.env}.aws.${var.root_domain}"

  vpc {
    vpc_id = aws_vpc.env[count.index].id
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${local.env}.aws.${var.root_domain}"
    }
  )
}

resource "aws_route53_record" "env_private_caa" {
  count = var.enable_vpc_env

  name    = "CAA"
  records = var.caa_records
  type    = "CAA"
  ttl     = "300"
  zone_id = aws_route53_zone.env_private[0].zone_id
}
