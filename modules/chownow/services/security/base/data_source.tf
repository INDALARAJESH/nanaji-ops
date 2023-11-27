
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_s3_bucket" "s3_access_logs" {
  bucket = "cn-s3-access-logs-${local.env}"
}
