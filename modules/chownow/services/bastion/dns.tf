module "r53_bastion_host" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"

  name    = "${var.service}${var.dns_name_suffix}"
  zone_id = data.aws_route53_zone.svpn_public_zone.zone_id
  type    = "A"
  records = module.ec2_bastion.public_ips
}
