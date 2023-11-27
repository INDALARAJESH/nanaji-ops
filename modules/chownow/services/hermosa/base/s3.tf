#####################
# Public S3 Buckets #
#####################

# public facebook bucket
module "cn_hermosa_facebook" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  count = var.enable_bucket_facebook

  acl           = "public-read"
  bucket_name   = local.bucket_facebook
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false
  policy               = templatefile("${path.module}/templates/s3/legacy_allow.json.tpl", { bucket_name = local.bucket_facebook })

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_facebook
    }
  ]
}


# public google datafeed buceket
module "cn_hermosa_google_datafeed" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  count = var.enable_bucket_google_datafeed

  acl           = "public-read"
  bucket_name   = local.bucket_google_datafeed
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false
  policy               = templatefile("${path.module}/templates/s3/legacy_allow.json.tpl", { bucket_name = local.bucket_google_datafeed })

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_google_datafeed
    }
  ]
}

module "cn_hermosa_single_platform" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  count = var.enable_bucket_single_platform

  acl           = "public-read"
  bucket_name   = local.bucket_single_platform
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false
  policy               = templatefile("${path.module}/templates/s3/legacy_allow.json.tpl", { bucket_name = local.bucket_single_platform })

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_single_platform
    }
  ]
}


######################
# Private S3 Buckets #
######################

# private hermosa merchant bucket
module "cn_hermosa_merchant" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  count = var.enable_bucket_merchant

  bucket_name   = local.bucket_merchant
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST"]
      allowed_origins = ["https://${local.env}.${var.svpn_subdomain}.${var.domain}"]
      expose_headers  = ["ETag", "x-amz-meta-custom-header"]
    },
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST"]
      allowed_origins = ["https://admin.${local.env}.${var.svpn_subdomain}.${var.domain}"]
      expose_headers  = ["ETag", "x-amz-meta-custom-header"]
    },
  ]

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_merchant
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


# private hermosa onboarding bucket
module "cn_hermosa_onboarding" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  count = var.enable_bucket_onboarding

  bucket_name   = local.bucket_onboarding
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_onboarding
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

# private hermosa static assets bucket
module "cn_hermosa_static_assets" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  count = var.enable_bucket_static_assets

  bucket_name   = local.bucket_static_assets
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
      max_age_seconds = 3000
    },
  ]

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_static_assets
    }
  ]
}

# private hermosa audit archive bucket
module "cn_hermosa_audit" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.3"

  acl = "private"

  count = var.enable_bucket_audit

  bucket_name   = local.bucket_audit
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_audit
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
