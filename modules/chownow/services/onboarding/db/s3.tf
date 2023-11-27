# DEPRECATION NOTICE— Scheduled to be removed once all menu files expire. TODO
module "s3_menu_files" {
  source               = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.2"
  bucket_name          = local.s3_bucket_name
  env                  = var.env
  env_inst             = var.env_inst
  service              = var.service
  attach_public_policy = false
  policy               = templatefile("${path.module}/templates/s3_policy.json.tpl", { bucket_name = local.s3_bucket_name })

  cors_rule = [{
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = [
      var.cors_allow_origin_url
    ]
    expose_headers  = []
    max_age_seconds = 3000
    },
    {
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
  }]

  lifecycle_rule = [
    {
      enabled = true
      expiration = {
        days = local.s3_object_expiration_days
      }
    }
  ]
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = module.s3_menu_files.bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "s3_onboarding_files" {
  bucket = local.onboarding_files_s3_bucket_name

  tags = {
    Environment         = var.env
    EnvironmentInstance = var.env_inst
    Service             = var.service
    ManagedBy           = "Terraform"
    Name                = local.onboarding_files_s3_bucket_name
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_onboarding_files_lifecycle" {
  bucket = aws_s3_bucket.s3_onboarding_files.id

  rule {
    id     = "all-onboarding-files"
    status = "Enabled"

    expiration {
      days = local.s3_object_expiration_days
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_onboarding_files_public_access" {
  bucket = aws_s3_bucket.s3_onboarding_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "s3_onboarding_files_ownership" {
  bucket = aws_s3_bucket.s3_onboarding_files.id

  rule {
    object_ownership = "ObjectWriter"
  }

  depends_on = [
    aws_s3_bucket_public_access_block.s3_onboarding_files_public_access,
  ]
}

resource "aws_s3_bucket_acl" "s3_onboarding_files_acl" {
  bucket = aws_s3_bucket.s3_onboarding_files.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.s3_onboarding_files_ownership,
  ]
}

resource "aws_s3_bucket_cors_configuration" "s3_onboarding_files_cors" {
  bucket = aws_s3_bucket.s3_onboarding_files.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = [
      var.cors_allow_origin_url
    ]
    expose_headers  = []
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}
