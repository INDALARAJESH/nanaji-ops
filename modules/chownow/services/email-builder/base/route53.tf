# Create DNS record only when not in ncp baceause in this case the DNS record is in prod acount, chownowcdn zone amd must be created separately
module "r53_emailbuilder" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"
  count   = local.is_not_prod
  zone_id = data.aws_route53_zone.chownowcdn_dot_com[count.index].zone_id
  name    = local.bucket_name
  type    = "CNAME"
  records = [
    "${local.bucket_name}.cdn.cloudflare.net"
  ]
}
