resource "aws_s3_bucket" "cloudflare_logs" {
  bucket = local.s3_bucket_name
  acl    = var.bucket_acl
  policy = data.template_file.iam_policy_cloudflare.rendered

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  lifecycle_rule {
    enabled = var.s3_lifecycle_rule_enabled
    id      = "transition_and_expiration"

    tags = {
      "rule"      = "/"
      "autoclean" = "true"
    }

    transition {
      days          = var.transition_days
      storage_class = var.transition_storage_class
    }

    expiration {
      days = var.object_expiration
    }
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = var.abort_incomplete_days
    enabled                                = var.s3_lifecycle_rule_enabled
    id                                     = "abort-incomplete"
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.s3_bucket_name,
    )
  )
}
