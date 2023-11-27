module "env_file_bucket" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  bucket_name = "cn-${local.full_service}-env-file-${local.env}"
  env         = local.env
  service     = local.full_service

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
