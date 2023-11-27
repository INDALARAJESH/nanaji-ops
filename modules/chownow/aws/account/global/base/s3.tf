
# Bucket to store ALB logs from any service created in a given environment
module "bucket_alb_logs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.2"

  count = var.enable_bucket_alb_logs

  acl                           = "log-delivery-write"
  attach_lb_log_delivery_policy = true
  bucket_name                   = local.bucket_alb_logs
  env                           = var.env
  env_inst                      = var.env_inst
  force_destroy                 = true
  service                       = "monitoring"

  attach_public_policy = false

  lifecycle_rule = [
    {
      enabled = true
      id      = local.bucket_alb_logs
      prefix  = "AWSLogs/"

      tags = {
        rule      = "log"
        autoclean = "true"
      }

      transition = [
        {
          days          = local.alb_logs_transition_days
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days = local.alb_logs_expiration_days
      }
    },
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
