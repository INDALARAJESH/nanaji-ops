#######
# IAM #
#######
data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid = "AWSCloudTrailAclCheck"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      "arn:aws:s3:::${local.cloudtrail_bucket_name}",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:trail/${local.cloudtrail_name}"]
    }
  }

  statement {
    sid = "AWSCloudTrailWrite"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${local.cloudtrail_bucket_name}/${var.s3_key_prefix}/AWSLogs/${data.aws_caller_identity.current.id}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:trail/${local.cloudtrail_name}"]
    }
  }
}


######
# S3 #
######

resource "aws_s3_bucket" "cloudtrail_logs" {

  bucket = local.cloudtrail_bucket_name
  policy = data.aws_iam_policy_document.cloudtrail.json

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.cloudtrail_bucket_name,
    )
  )
}

resource "aws_s3_bucket_acl" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    id     = var.s3_key_prefix
    status = var.s3_lifecycle_rule_enabled

    filter {
      and {
        tags = {
          "rule"      = var.s3_key_prefix
          "autoclean" = "true"
        }

        prefix = "${var.s3_key_prefix}/"
      }
    }

    transition {
      days          = var.transition_days
      storage_class = var.transition_storage_class
    }

    expiration {
      days = var.object_expiration
    }
  }

  rule {
    id     = "abort-incomplete"
    status = var.s3_lifecycle_rule_enabled

    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_incomplete_days
    }
  }
}



resource "aws_s3_bucket_public_access_block" "cloudtrail_logs" {
  bucket                  = aws_s3_bucket.cloudtrail_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



output "trail_bucket_id" {
  value = aws_s3_bucket.cloudtrail_logs.id
}

output "trail_bucket_arn" {
  value = aws_s3_bucket.cloudtrail_logs.arn
}


##############
# CloudTrail #
##############

resource "aws_cloudtrail" "bucket_monitor" {
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  name                          = local.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  s3_key_prefix                 = var.s3_key_prefix

  event_selector {
    read_write_type           = var.event_selector_rwt
    include_management_events = var.event_selector_ime

    data_resource {
      type   = var.data_resource_type
      values = concat(var.monitored_buckets_list, ["${aws_s3_bucket.syslog.arn}/"])
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.cloudtrail_name,
    )
  )
}

output "trail_id" {
  value = aws_cloudtrail.bucket_monitor.id
}

output "trail_arn" {
  value = aws_cloudtrail.bucket_monitor.arn
}


############################
# Datadog Lambda Forwarder #
############################

module "datadog_log_forward" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/log-forwarder?ref=aws-datadog-log-forwarder-v2.1.0"

  count = var.enable_cloudtrail_dd

  env     = var.env
  service = var.service

}

resource "aws_s3_bucket_notification" "cloudtrail_bucket" {

  count = var.enable_cloudtrail_dd

  bucket = aws_s3_bucket.cloudtrail_logs.id
  lambda_function {
    lambda_function_arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${module.datadog_log_forward[0].name}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.s3_key_prefix}/AWSLogs/"
    filter_suffix       = ".gz"
  }

  depends_on = [
    module.datadog_log_forward[0],
  ]
}
