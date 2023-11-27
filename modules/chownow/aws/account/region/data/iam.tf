
######################
# DATA IAM RESOURCES #
######################

resource "aws_iam_role" "data_serverless_lambda_role" {
  name               =  "${var.env}-serverless-lambda-role"
  assume_role_policy = file("${path.module}/files/assume_role.json")

  tags = { "Name" = "data-serverless-lambda-role" }
}

resource "aws_iam_role_policy_attachment" "lambda_execution_builtin" {
  role       = aws_iam_role.data_serverless_lambda_role.id
  policy_arn = data.aws_iam_policy.lambda_basic_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "vpc_execution_builtin" {
  role       = aws_iam_role.data_serverless_lambda_role.id
  policy_arn = data.aws_iam_policy.lambda_vpc_execution_policy.arn
}
data "aws_iam_policy_document" "allow_s3_secertmanager" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Put*",
      "s3:Get*",
      "s3:List*",
    ]
    resources = ["*"]
 }

  statement {
    sid     = "AllowReadSecrets"
    effect  = "Allow"
    actions = [
       "secretsmanager:GetSecretValue",
       "secretsmanager:DescribeSecret*",
       "secretsmanager:Get*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "data_serverless_lambda_policy" {
  name        = "data-serverless-lambda-policy"
  description = "policy for data-serverless-lambda-role"
  policy      = data.aws_iam_policy_document.allow_s3_secertmanager.json

  tags =  { "Name" = "data-serverless-lambda-role" }
}

resource "aws_iam_role_policy_attachment" "data_serverless_lambda_policy_attachment" {
  role       = aws_iam_role.data_serverless_lambda_role.id
  policy_arn = aws_iam_policy.data_serverless_lambda_policy.arn
}

