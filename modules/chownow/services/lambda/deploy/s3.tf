# Create cn-ENV-repo bucket for Lambdas
resource "aws_s3_bucket" "cn-repo" {
  bucket = local.bucket_name
  acl    = "private"

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = local.bucket_name
    })
  )
}
