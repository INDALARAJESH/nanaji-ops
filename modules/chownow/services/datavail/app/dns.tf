# work around because prod doesnt have a dedicated public svpn zone
module "a_record_prod" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  count = var.enable_a_record == 1 && local.env == "prod" ? 1 : 0

  name    = "${local.name}${count.index}.${local.env}.svpn"
  records = module.bastion.public_ips
  type    = "A"
  zone_id = data.aws_route53_zone.chownow_dot_com[0].zone_id
}
