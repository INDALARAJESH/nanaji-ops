module "quarantine_bucket" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  count = var.enable_bucket_quarantine

  bucket_name = local.bucket_name
  env         = var.env
  env_inst    = var.env_inst
  policy      = templatefile("${path.module}/templates/quarantine_bucket_policy.json", { bucket_name = local.bucket_name })
  service     = var.service

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

}
