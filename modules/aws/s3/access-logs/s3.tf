resource "aws_s3_bucket" "s3_access_logs" {
  bucket = local.s3_bucket_name

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.s3_bucket_name }
  )
}


resource "aws_s3_bucket_acl" "s3_access_logs" {
  bucket = aws_s3_bucket.s3_access_logs.id
  acl    = "log-delivery-write"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "s3_access_logs" {
  bucket = aws_s3_bucket.s3_access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "s3_access_logs" {
  bucket = aws_s3_bucket.s3_access_logs.id

  rule {
    id     = var.s3_key_prefix
    status = var.s3_lifecycle_rule_enabled

    filter {
      and {
        tags = {
          "rule"      = var.s3_key_prefix
          "autoclean" = "true"
        }

        prefix = "${var.s3_key_prefix}/"
      }
    }

    transition {
      days          = var.transition_days
      storage_class = var.transition_storage_class
    }

    expiration {
      days = var.object_expiration
    }
  }

  rule {
    id     = "abort-incomplete"
    status = var.s3_lifecycle_rule_enabled

    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_incomplete_days
    }
  }
}




resource "aws_s3_bucket_public_access_block" "s3_access_logs" {
  bucket                  = aws_s3_bucket.s3_access_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
