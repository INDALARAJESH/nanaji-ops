data "aws_route53_zone" "forwarder" {
  name         = "${var.domain}."
  private_zone = false
}

output "chownow_dot_com_zone_id" {
  value = data.aws_route53_zone.forwarder.zone_id
}
