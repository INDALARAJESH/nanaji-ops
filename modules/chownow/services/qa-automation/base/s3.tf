module "qa_automation_bucket" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  bucket_name = "cn-${var.service}-${var.env}"
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
}
