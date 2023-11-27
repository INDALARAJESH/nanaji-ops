resource "aws_kinesis_stream" "launchdarkly" {
  name        = "${var.service}-${var.env}"
  shard_count = var.shard_count

  tags = merge(
    local.common_tags
  )
}

module "launchdarkly_s3_bucket" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  acl           = "private"
  bucket_name   = "cn-datastream-${var.service}-${var.env}"
  env           = var.env
  env_inst      = ""
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_kinesis_firehose_delivery_stream" "launchdarkly" {
  name        = "${var.service}-${var.env}-kinesis-firehose"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = module.launchdarkly_s3_bucket.bucket_arn
  }

  kinesis_source_configuration {
    role_arn           = aws_iam_role.firehose.arn
    kinesis_stream_arn = aws_kinesis_stream.launchdarkly.arn
  }

  tags = merge(
    local.common_tags
  )
}
