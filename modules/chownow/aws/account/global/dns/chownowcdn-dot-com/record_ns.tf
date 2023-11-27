resource "aws_route53_record" "nameservers_chownowcdn_uatload" {

  name    = "uatload.${var.domain_chownowcdn}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownowcdn_dot_com.zone_id
  records = data.aws_route53_zone.delegate_uatload_chownowcdn_dot_com.name_servers
}

resource "aws_route53_record" "nameservers_chownowcdn_uat" {

  name    = "uat.${var.domain_chownowcdn}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownowcdn_dot_com.zone_id
  records = data.aws_route53_zone.delegate_uat_chownowcdn_dot_com.name_servers
}

resource "aws_route53_record" "nameservers_chownowcdn_stg" {

  name    = "stg.${var.domain_chownowcdn}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownowcdn_dot_com.zone_id
  records = data.aws_route53_zone.delegate_stg_chownowcdn_dot_com.name_servers
}

resource "aws_route53_record" "nameservers_chownowcdn_qa" {

  name    = "qa.${var.domain_chownowcdn}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownowcdn_dot_com.zone_id
  records = data.aws_route53_zone.delegate_qa_chownowcdn_dot_com.name_servers
}

resource "aws_route53_record" "nameservers_chownowcdn_dev" {

  name    = "dev.${var.domain_chownowcdn}"
  ttl     = 30
  type    = "NS"
  zone_id = data.aws_route53_zone.chownowcdn_dot_com.zone_id
  records = data.aws_route53_zone.delegate_dev_chownowcdn_dot_com.name_servers
}
