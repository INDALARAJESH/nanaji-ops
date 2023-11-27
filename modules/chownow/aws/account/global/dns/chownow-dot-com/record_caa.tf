module "caa_dev_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "dev.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "CAA"
  records = [
    "0 iodef \"mailto:security@chownow.com\"",
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"letsencrypt.org\""
  ]
}
