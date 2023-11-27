#######
# IAM #
#######

resource "aws_iam_user" "syslog" {
  name = "syslog-${local.env}"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", "syslog-${local.env}",
    )
  )
}


data "aws_iam_policy_document" "syslog" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.syslog.arn,
      "${aws_s3_bucket.syslog.arn}/*",
    ]
  }
}

resource "aws_iam_user_policy" "syslog" {
  name   = "syslog"
  user   = aws_iam_user.syslog.name
  policy = data.aws_iam_policy_document.syslog.json
}


resource "aws_iam_access_key" "syslog" {
  count = var.create_syslog_access_key

  user = aws_iam_user.syslog.name
}


output "user_access_key" {
  value = var.create_syslog_access_key == 1 ? aws_iam_access_key.syslog[0].id : ""
}

output "user_secret_key" {
  value     = var.create_syslog_access_key == 1 ? aws_iam_access_key.syslog[0].secret : ""
  sensitive = true
}


######
# S3 #
######

resource "aws_s3_bucket" "syslog" {
  bucket              = local.syslog_bucket_name
  object_lock_enabled = true

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.syslog_bucket_name,
    )
  )
}

resource "aws_s3_bucket_acl" "syslog" {
  bucket = aws_s3_bucket.syslog.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_object_lock_configuration" "syslog" {
  bucket = aws_s3_bucket.syslog.bucket

  rule {
    default_retention {
      mode = var.s3_object_lock_configuration_mode
      days = var.s3_object_lock_configuration_days
    }
  }
}

resource "aws_s3_bucket_logging" "syslog" {
  bucket = aws_s3_bucket.syslog.id

  target_bucket = data.aws_s3_bucket.s3_access_logs.id
  target_prefix = "${var.s3_key_prefix}/"
}

output "syslog_bucket_name" {
  description = "syslog bucket name"
  value       = aws_s3_bucket.syslog.id
}
