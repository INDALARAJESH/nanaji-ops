######################
# Private S3 Buckets #
######################

# sagemaker bucket
module "cn_sagemaker" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  acl           = "private"
  bucket_name   = "cn-sagemaker-${local.env}"
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

# cn-production-data-eng bucket
module "cn_production_data_eng" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  acl           = "private"
  bucket_name   = "cn-production-data-eng"
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

# cn-development-data-eng bucket
module "cn_development_data_eng" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  acl           = "private"
  bucket_name   = "cn-development-data-eng"
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
