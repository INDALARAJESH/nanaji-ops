## S3

# A bucket for the app. Not using a module here because of the need for logging {}
resource "aws_s3_bucket" "app" {
  bucket = local.s3_bucket_name
  acl    = "private"

  logging {
    target_bucket = data.aws_s3_bucket.s3_access_logs.id
    target_prefix = "${local.s3_bucket_name}/"
  }

  dynamic "cors_rule" {
    for_each = var.cors_rule
    content {
      allowed_headers = cors_rule.value["allowed_headers"]
      allowed_methods = cors_rule.value["allowed_methods"]
      allowed_origins = cors_rule.value["allowed_origins"]
      expose_headers  = cors_rule.value["expose_headers"]
      max_age_seconds = cors_rule.value["max_age_seconds"]

    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.s3_bucket_name
    )
  )
}

# The lambda
data "archive_file" "lambda-s3-cleanup-source" {
  type        = "zip"
  source_file = "${path.module}/files/s3_cleanup.py"
  output_path = "${path.module}/files/s3_cleanup.zip"
}
resource "aws_lambda_function" "lambda-s3-cleanup" {
  filename         = data.archive_file.lambda-s3-cleanup-source.output_path
  function_name    = "s3_cleanup-${aws_s3_bucket.app.id}"
  handler          = "s3_cleanup.handler"
  runtime          = "python3.7"
  timeout          = 60 # max seconds allowed to run
  source_code_hash = data.archive_file.lambda-s3-cleanup-source.output_base64sha256
  role             = data.aws_iam_role.lambda_s3_cleanup.arn
  publish          = var.publish
  environment {
    variables = {
      RETAIN = 5
      PREFIX = var.filter_prefix
    }
  }

  lifecycle {
    ignore_changes = [environment, filename, last_modified, source_code_hash]
  }

  tags = {
    Name                = "s3_cleanup-${aws_s3_bucket.app.id}"
    Environment         = var.env
    EnvironmentInstance = var.env_inst
    App                 = "s3_cleanup"
  }
}
# access for the lambda to do its thing
data "aws_iam_policy_document" "lambda-s3-cleanup-codebuild-bucket-policy-document" {
  statement {
    actions = ["s3:ListBucket", "s3:DeleteObject"]
    resources = [
      aws_s3_bucket.app.arn,
      "${aws_s3_bucket.app.arn}/*",
    ]
  }
}
resource "aws_iam_policy" "lambda-s3-cleanup-codebuild-bucket-policy" {
  name   = "lambda-s3-cleanup-codebuild-bucket-policy-${aws_s3_bucket.app.id}"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda-s3-cleanup-codebuild-bucket-policy-document.json
}
resource "aws_iam_role_policy_attachment" "lambda-s3-cleanup-codebuild-bucket-policy-attachment" {
  role       = data.aws_iam_role.lambda_s3_cleanup.name
  policy_arn = aws_iam_policy.lambda-s3-cleanup-codebuild-bucket-policy.arn
}

# trigger from the s3 bucket
# I don't get this - this aws_lambda_permission does not appear to be created when
# you create the trigger in console, and it works, but I can't terraform the trigger
# without this resource /shrug
resource "aws_lambda_permission" "bucket-allow" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-s3-cleanup.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.app.arn
}
resource "aws_s3_bucket_notification" "app-dashboard-bucket-trigger" {
  bucket = aws_s3_bucket.app.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda-s3-cleanup.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.filter_prefix # the "folder"
    filter_suffix       = var.filter_suffix # don't re-run for every object in the "folder"...
  }
}

resource "aws_s3_bucket_policy" "app_s3_policy" {
  depends_on = [aws_cloudfront_origin_access_identity.app_origin_access_identity]
  bucket     = aws_s3_bucket.app.id

  policy = <<POLICY
{
   "Version":"2008-10-17",
   "Id":"PolicyForCloudFrontPrivateContent",
   "Statement":[
      {
         "Sid":"1",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.app_origin_access_identity.id}"
         },
         "Action":"s3:GetObject",
         "Resource":"${aws_s3_bucket.app.arn}/*"
      }
   ]
}
POLICY
}
