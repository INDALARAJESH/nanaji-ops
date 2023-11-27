module "cloudfront" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudfront/distribution?ref=aws-cloudfront-distribution-v2.0.0"
  count                  = var.enable_cloudfront_distribution
  env                    = var.env
  env_inst               = var.env_inst
  service                = var.service
  acm_certificate_arn    = data.aws_acm_certificate.chownowcdn.arn
  bucket_name            = module.cn_hermosa_static_assets[count.index].bucket_name
  bucket_arn             = module.cn_hermosa_static_assets[count.index].bucket_arn
  bucket_domain_name     = module.cn_hermosa_static_assets[count.index].bucket_domain_name
  aliases                = var.cdn_cnames
  viewer_protocol_policy = "allow-all"
  custom_error_response = [{
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }]
  headers = [
    "Origin",
    "Access-Control-Request-Headers",
    "Access-Control-Request-Method",
  ]
}

module "hermosa_static_cdn_dns" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.2"
  count  = var.enable_cloudfront_distribution == 1 ? "${length(var.cdn_cnames)}" : 0

  name    = element(var.cdn_cnames, count.index)
  zone_id = data.aws_route53_zone.chownowcdn_com_pub_zone.zone_id
  type    = "CNAME"
  ttl     = 300
  records = [
    module.cloudfront[0].domain_name
  ]
}
