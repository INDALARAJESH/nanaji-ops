# Role allowing Jenkins deploy lambda function
resource "aws_iam_user_policy" "lambda-deploy-policy-lambda" {
  name   = "lambda-deploy"
  user   = local.service_user
  policy = data.aws_iam_policy_document.lambda-deploy-policy-document-lambda.json
}

# Role allowing Jenkins to read cn-{env}-repo
resource "aws_iam_user_policy" "lambda-deploy-policy-s3" {
  name   = "lambda-s3"
  user   = local.service_user
  policy = data.aws_iam_policy_document.lambda-deploy-policy-document-s3.json
}
