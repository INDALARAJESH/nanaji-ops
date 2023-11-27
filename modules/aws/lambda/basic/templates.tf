data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    # sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_base_policy_s3" {
  count = var.lambda_s3 ? 1 : 0
  statement {
    # sid    = ""
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = [
      format("arn:aws:logs:*:*:*")
    ]
  }
  statement {
    # sid    = ""
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      format("arn:aws:s3:::%s/*", aws_s3_bucket.lambda_artifacts[0].id)
    ]
  }
  statement {
    # sid    = ""
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      format("arn:aws:s3:::%s", aws_s3_bucket.lambda_artifacts[0].id)
    ]
  }
}

data "aws_iam_policy_document" "lambda_base_policy_ecr" {
  count = var.lambda_ecr ? 1 : 0
  statement {
    # sid    = ""
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = [
      format("arn:aws:logs:*:*:*")
    ]
  }
  statement {
    sid    = "LambdaECRImageRetrievalPolicy"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = [
      format("*")
    ]
  }
}
