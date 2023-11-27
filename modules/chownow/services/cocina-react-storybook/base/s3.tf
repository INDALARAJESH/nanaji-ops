resource "aws_s3_bucket" "s3_cocina_react_storybook" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_ownership_controls" "controls" {
  bucket = aws_s3_bucket.s3_cocina_react_storybook.id
  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_ownership_controls.controls]

  bucket = aws_s3_bucket.s3_cocina_react_storybook.id
  acl    = var.acl
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.s3_cocina_react_storybook.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_cocina_react_storybook.id
  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_website_configuration" "s3_cocina_react_storybook_web_config" {
  bucket = aws_s3_bucket.s3_cocina_react_storybook.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "policies" {
  bucket     = aws_s3_bucket.s3_cocina_react_storybook.id

  policy = data.aws_iam_policy_document.s3_policy_document.json
}
