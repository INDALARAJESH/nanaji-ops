module "cn_revenue_io" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.2"

  count = var.enable_bucket_revenue_io

  bucket_name   = local.bucket_revenue_io
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false
  policy               = templatefile("${path.module}/templates/s3/revenue_io_allow.json.tpl", { bucket_name = local.bucket_revenue_io })

}
