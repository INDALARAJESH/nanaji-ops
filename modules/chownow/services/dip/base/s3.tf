module "tf_statefile" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  count = var.enable_bucket_tf_statefile

  bucket_name = "cn-${var.service}-${local.env}"
  env         = var.env
  env_inst    = var.env_inst
  service     = var.service

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  extra_tags = {
    TFModule = var.tag_tfmodule
  }

}
