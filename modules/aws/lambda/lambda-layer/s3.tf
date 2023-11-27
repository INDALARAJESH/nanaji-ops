# Bucket to store lambda layer zip files
resource "aws_s3_bucket" "lambda_artifacts" {
  bucket = local.bucket_name

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
    var.extra_tags,
    { "Name" = local.bucket_name }
  )
}

# Initial Dummy Lambda Zip
resource "aws_s3_bucket_object" "first_lambda_zip" {
  bucket = aws_s3_bucket.lambda_artifacts.id
  key    = var.first_lambda_zip_key
  source = "${path.module}/files/layer.zip"

  lifecycle {
    ignore_changes = ["key", "source"]
  }

  depends_on = ["aws_s3_bucket.lambda_artifacts"]
}

# Block public access
resource "aws_s3_bucket_public_access_block" "private" {
  count = var.s3_acl == "private" ? 1 : 0

  bucket = aws_s3_bucket.lambda_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
