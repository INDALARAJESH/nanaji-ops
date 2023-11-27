resource "aws_s3_bucket" "spacelift_test" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.env
    BucketType  = "private"
  }
}

resource "aws_s3_bucket_acl" "spacelift_test" {
  bucket = aws_s3_bucket.spacelift_test.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "spacelift_test" {
  bucket = aws_s3_bucket.spacelift_test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
