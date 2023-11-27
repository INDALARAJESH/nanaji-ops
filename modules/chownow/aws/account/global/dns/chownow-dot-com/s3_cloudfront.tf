# Public bucket used to redirect request to apex domain chownow.com to www.chownow.com
resource "aws_s3_bucket" "redirect" {
  bucket = "chownow.com"

  tags = merge(
    {
      Name = "chownow.com"
    },
    local.common_tags
  )
}

resource "aws_s3_bucket_ownership_controls" "redirect" {
  bucket = aws_s3_bucket.redirect.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "redirect" {
  bucket = aws_s3_bucket.redirect.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "redirect" {
  depends_on = [
    aws_s3_bucket_ownership_controls.redirect,
    aws_s3_bucket_public_access_block.redirect,
  ]

  bucket = aws_s3_bucket.redirect.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "redirect" {
  bucket = aws_s3_bucket.redirect.id

  redirect_all_requests_to {
    host_name = "www.chownow.com"
    protocol  = "https"
  }
}
