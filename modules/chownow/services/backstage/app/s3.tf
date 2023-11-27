module "alb_logs_bucket" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  count = var.alb_access_logs_enabled == true ? 1 : 0

  bucket_name = "${var.service}-alb-logs-${var.env}"
  env         = var.env
  service     = var.service

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

}

