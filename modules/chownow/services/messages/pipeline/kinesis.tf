module "cn_events_firehose_s3" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v2.0.2"

  bucket_name = local.bucket_name
  env         = local.env
  service     = var.service

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_kinesis_firehose_delivery_stream" "cn_events_s3_stream" {
  name        = local.firehose_delivery_stream_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = module.cn_events_firehose_s3.bucket_arn

    buffer_size = 64

    dynamic_partitioning_configuration {
      enabled = "true"
    }

    prefix              = "!{partitionKeyFromQuery:subject}/!{timestamp:yyyy}/!{timestamp:MM}/!{timestamp:dd}/!{timestamp:HH}/"
    error_output_prefix = "errors/"

    processing_configuration {
      enabled = "true"

      processors {
        type = "MetadataExtraction"
        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }
        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{subject:.Subject}"
        }
      }
    }
  }

  tags = merge(
    local.common_tags
  )
}

resource "aws_sns_topic_subscription" "cn_events_firehose_target" {
  topic_arn             = local.topic_arn
  protocol              = "firehose"
  endpoint              = aws_kinesis_firehose_delivery_stream.cn_events_s3_stream.arn
  subscription_role_arn = aws_iam_role.firehose_sns_role.arn
}
