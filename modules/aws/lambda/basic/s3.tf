# Bucket to store lambda zip files
resource "aws_s3_bucket" "lambda_artifacts" {
  count  = var.lambda_s3 ? 1 : 0
  bucket = "${var.bucket_prefix}${replace(local.lambda_classification, "_", "-")}"

  acl           = var.s3_acl
  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_sse_algorithm
      }
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

# Initial Dummy Lambda Zip
resource "aws_s3_bucket_object" "first_lambda_zip" {
  count  = var.lambda_s3 ? 1 : 0
  bucket = aws_s3_bucket.lambda_artifacts[0].id
  key    = var.first_lambda_zip_key
  source = "${path.module}/files/lambda.zip"

  lifecycle {
    ignore_changes = [key, source]
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "private" {
  count               = var.lambda_s3 ? 1 : 0
  bucket              = aws_s3_bucket.lambda_artifacts[0].id
  block_public_acls   = true
  block_public_policy = true
}
