module "s3_bucket" {
  source               = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.2"
  count                = var.enable_execute_command_logging ? 1 : 0
  bucket_name          = local.bucket_name
  env                  = var.env
  env_inst             = var.env_inst
  force_destroy        = false
  service              = var.service
  attach_public_policy = false
  versioning           = {}
  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_name
    }
  ]
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
