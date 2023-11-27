module "wildcard_svpn_cert" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/acm/wildcard?ref=aws-acm-wildcard-v2.0.0"
  env           = var.env
  dns_zone_name = var.svpn_dns_zone_name
}
