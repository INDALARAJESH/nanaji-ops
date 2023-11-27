#
# OPS-3954 SPF for Google Workspace
#

module "txt_spf_verifications_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = var.domain
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"

  records = [
    "v=spf1 ip4:167.89.0.0/17 ip4:168.245.0.0/17 ip4:23.21.109.197 ip4:23.21.109.212 ip4:147.160.167.0/26 include:amazonses.com include:sendgrid.net include:_spf.google.com include:mktomail.com include:_spf.salesforce.com ~all",
    "onetrust-domain-verification=ac166b3ef182403f9b5ac0d1f0ea4a04",
    "stripe-verification=3fc3ae656cc0de9267067f471c0d824eb5b42d5b647ce9847e00b45a2b6fd404",
    "stripe-verification=9fcf3297d61b9cbbe552c34e939e2090232d12a8bbb447949c29b528f3e71e79",
    "atlassian-domain-verification=edMHCaQ4ynoeSFVObF+tWLMAks1jIhRTaGMPOp3EqUj8jvwouIdUr++01ZseafkO",
    "google-site-verification=fgUPxt5GuOxPkiri0vD7Qi7dXlVj0jCOjVWn0MdtT0U",
    "miro-verification=5512d887112fe3be6af56597f5cdaabafd40fac2",
    "1password-site-verification=T2GCICU7ZJFUVH65E3PJT3DIGY",
    "stripe-verification=ff56f5bce22125556cb734d9b45e60ef33efbeb9d2e083f11e8e47344077ac3a",
    "stripe-verification=9e0e35974cf79f25636c63dc9ee63280ce6319d5a3096077b0e59bdca2908233",
    "stripe-verification=17a1199be9e0f674a0d814ffa6423c7245c04a4f6e1a049bd8c92e1833530970"

  ]
}

#
# OPS-3955 DKIM for Google Workspace
#

module "txt_gmail_dkim_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "gmail._domainkey.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2jnzIa21ePA1Bigceftcb0qF+jqRAJySSTr40AYjWE0iXB2IYnA0lcsWjLbc6fvMzE4ORpUVvSR0vljIyEZX1/pppa3Dc55fPB3S6Ll8qW1zR6YFqyeAyUbj44HOQB01vPXK6SsHVXucqXGdUF7\"\"wgyutLhQTJyWbrr8ET2vNoamp2lJ7tYecDbI+B3+qXIbXjTWCjn7yfc0DMT7ltcDjw6M9N3DJBlfzl8K3OUP82tNtnlqaJqLY6v9y6pAS9YZpj1zWVwfY6Pj1bBzNDheW1hm1zYTgLtyE8nd9Rb7FzF9Fs+p5ZTBfQFQVUah8K32oJtVfyOMKWEDUmxVukifa+wIDAQAB"
  ]
}

#
# OPS-3960 DMARC for Google Workspace
#

module "txt_dmarc_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "_dmarc.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "v=DMARC1;p=quarantine;rua=mailto:dmarc_agg@dmarc.everest.email,mailto:dmarc@chownow.com;ruf=mailto:dmarc_fr@dmarc.everest.email;fo=1;pct=100;adkim=r;aspf=r"
  ]
}

module "txt_partnerstack_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "partnerstack.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "google-site-verification=NH32q_x14tQsZszrI1t5Pi2fAmcICg_9Sgx1ME-VuMc"
  ]
}

## OPS-2614 Pinterest Business Account ##

module "txt_pinterest_get_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "get.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "pinterest-site-verification=b736506f42c28ab1a00403b3689228d2"
  ]
}

# module "txt_pinterest_eat_chownow_com" {
#   source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

#   name    = "eat.${var.domain}"
#   zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
#   type    = "TXT"
#   records = [
#     "pinterest-site-verification=b736506f42c28ab1a00403b3689228d2"
#   ]
# }

module "txt_pinterest_direct_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "direct.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "pinterest-site-verification=b736506f42c28ab1a00403b3689228d2"
  ]
}

module "txt_wpengine_sso_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "_wpengine-sso-challenge.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "2DDKf58ScggKi72kpWVODJ6ono0"
  ]
}

## OPS-4731 Twilio Domain Verification ##

module "txt_twilio_verification_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "_twilio.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "twilio-domain-verification=90361ec1cfa7a80f58c8df6e93d9af21"
  ]
}

## OPS-4688 Twilio Short Links Domain Verification ##

module "txt_twilio_verification_r_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "_twilio.r.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "twilio-domain-verification=81a716edb94f11863bbe92c83734bd35"
  ]
}

## OPS-4840 DKIM for NetSuite Emailing ##

module "txt_netsuite_dkim_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "chownownetsuite._domainkey.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCt8C0lVJ1qEuw9Bam2i87ilmtEbtBopgCW9vbXpN5i7MroNp6gVATlCV5Z5YEwLW+7RTFdM5dSFjzpAVw/oeIVAmns+aOnPklfrhyh3AGe9v/ktsonIluYIO8R9FZpV/g8q2VE7/01Cf29Ja73b6AQPH3mJKDzhb1khCBMDr1TAwIDAQAB"
  ]
}

# OPS-5067 GitHub Domain Verification - DNS TXT Record
module "github_challenge_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  name    = "_github-challenge-ChowNow-org.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "91a289044c"
  ]
}

#
# OPS-5332 TXT for Sandbox Google Workspace
#

module "txt_sandbox_google_workspace_chownow_com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?depth=1&ref=aws-r53-record-basic-v2.0.1"

  name    = "test.${var.domain}"
  zone_id = data.aws_route53_zone.chownow_dot_com.zone_id
  type    = "TXT"
  records = [
    "google-site-verification=sK72-okhDqZp8TdMVW5v0B88-OpT9ZPiUoAZnyERvFM"
  ]
}
