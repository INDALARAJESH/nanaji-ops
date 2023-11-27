resource "aws_route53_record" "nameservers_uatload" {

  name    = "uatload.svpn.${var.domain}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  records = data.aws_route53_zone.delegate_uatload_chownow_dot_com.name_servers
}

resource "aws_route53_record" "nameservers_uat" {

  name    = "uat.svpn.${var.domain}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  records = data.aws_route53_zone.delegate_uat_chownow_dot_com.name_servers
}

resource "aws_route53_record" "nameservers_stg" {

  name    = "stg.svpn.${var.domain}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  records = data.aws_route53_zone.delegate_stg_chownow_dot_com.name_servers
}

resource "aws_route53_record" "nameservers_sandbox" {

  name    = "sandbox.svpn.${var.domain}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  records = data.aws_route53_zone.delegate_sandbox_chownow_dot_com.name_servers
}
