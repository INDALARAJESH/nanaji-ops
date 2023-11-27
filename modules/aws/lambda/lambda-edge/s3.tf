# The env-central lambda repo bucket
data "aws_s3_bucket" "repo_bucket" {
  bucket = "cn-${var.env}-repo"
}

# Initial Dummy Lambda Zip
resource "aws_s3_bucket_object" "first_lambda_zip" {
  bucket = data.aws_s3_bucket.repo_bucket.id
  key    = local.s3_key
  source = "${path.module}/files/lambda.zip"

  lifecycle {
    ignore_changes = [key, source]
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "private" {
  bucket = data.aws_s3_bucket.repo_bucket.id

  block_public_acls   = true
  block_public_policy = true
}
