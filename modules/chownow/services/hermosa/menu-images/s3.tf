module "cn_menuimages" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.2"

  acl           = "private"
  bucket_name   = local.bucket_name
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = false
  service       = var.service

  attach_public_policy = false


  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST", "PUT", "POST", "GET", "DELETE"]
      allowed_origins = local.allowed_origins
      expose_headers  = []
      max_age_seconds = 3000
    },
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
  )
}
