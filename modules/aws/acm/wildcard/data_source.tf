data "aws_route53_zone" "selected" {
  name = "${local.dns_validation_zone_name}."
}
