module "cloudfront_logs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  count = var.enable_bucket_cloudfront

  acl           = "log-delivery-write"
  bucket_name   = local.bucket_cloudfront
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  lifecycle_rule = [
      {
        abort_incomplete_multipart_upload_days = 366
        enabled                                = true
        id                                     = local.bucket_cloudfront
      }
    ]

}
