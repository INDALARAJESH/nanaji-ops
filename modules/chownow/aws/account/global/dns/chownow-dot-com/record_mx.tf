## OPS-2506 ##

module "mx_partnerstack_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "partnerstack.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "MX"
  records = [
    "1  aspmx.l.google.com.",
    "5  alt1.aspmx.l.google.com.",
    "5  alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com."
  ]
}

## OPS-5366 ##

module "mx_test_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "test.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "MX"
  ttl     = 3600

  records = [
    "1  aspmx.l.google.com.",
    "5  alt1.aspmx.l.google.com.",
    "5  alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com."
  ]
}
