module "cname_order_direct" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.2"
  count  = var.env == "prod" ? 0 : 1

  name    = "ordering-origin"
  zone_id = data.aws_route53_zone.private.zone_id
  ttl     = var.record_ttl
  type    = "CNAME"
  records = [data.aws_cloudfront_distribution.order_direct_cloudfront[count.index].domain_name]
}

module "cname_order_direct_production" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.2"
  count  = var.env == "prod" ? 1 : 0

  name    = "ordering-origin"
  zone_id = data.aws_route53_zone.private.zone_id
  ttl     = var.record_ttl
  type    = "CNAME"
  records = [var.production_app_order_direct_endpoint]
}
