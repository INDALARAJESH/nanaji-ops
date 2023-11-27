// Lambda Deployment Policies
data "aws_iam_policy_document" "lambda-deploy-policy-document-lambda" {
  statement {
    actions = [
      "lambda:UpdateFunctionConfiguration",
      "lambda:PublishLayerVersion",
      "lambda:UpdateFunctionCode",
      "lambda:ListLayerVersions",
      "lambda:GetLayerVersion",
      "lambda:GetFunctionConfiguration",
      "lambda:PublishVersion",
      "lambda:AddPermission",
      "lambda:ListFunctions",
      "lambda:CreateAlias",
      "lambda:UpdateAlias",
      "events:PutTargets",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda-deploy-policy-document-s3" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.cn-repo.arn,
      "arn:aws:s3:::*/*",
    ]
  }
}
