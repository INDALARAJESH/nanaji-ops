# Channels Data Service S3 resource(s)

module "channels_data_s3" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  bucket_name = local.channels_data_s3_bucket_name
  env         = local.env
  service     = var.service
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "clear_incomplete_uploads_after_1_day"
      enabled = true

      prefix = "chownow/menu/"

      abort_incomplete_multipart_upload_days = 1

    }
  ]

  extra_tags = local.extra_tags
}
