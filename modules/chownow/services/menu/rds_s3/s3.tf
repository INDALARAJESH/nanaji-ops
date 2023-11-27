module "rds_s3_bucket" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.3"

  acl           = "private"
  bucket_name   = local.s3_bucket_name
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = false
  service       = var.service

  attach_public_policy = false

  policy = templatefile("${path.module}/templates/s3_policy.json.tpl", { bucket_name = local.s3_bucket_name
  account = var.hermosa_account_id })

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.s3_bucket_name
    }
  ]
}

resource "aws_s3_bucket_ownership_controls" "ownership_preferred_controls" {
  bucket = local.s3_bucket_name

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
