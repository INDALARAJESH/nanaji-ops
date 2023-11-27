module "cn_mds_files" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.3"

  acl           = "private"
  bucket_name   = local.bucket_name
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = false
  service       = var.service

  attach_public_policy = false

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_name
    }
  ]
}
