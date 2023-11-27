module "chownowapi_public_dns_zone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/zone/public?ref=aws-r53-zone-public-v2.0.0"

  description   = "public dns zone for ${var.env}.chownowapi.com"
  domain_name   = "${var.env}.chownowapi.com"
}
