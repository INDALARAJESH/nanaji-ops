# ---------- DYNAMODB ---------------
resource "aws_iam_policy" "allow_ddb" {
  name        = "ddb-${var.app_name}-${local.env}"
  description = "Allows ${var.service} lambdas to query dynamodb"
  policy      = data.aws_iam_policy_document.allow_ddb_doc.json
}

# ---------- SECRETS ---------------
resource "aws_iam_policy" "allow_lambda_secret_lookup" {
  name        = "secrets-${var.app_name}-${local.env}"
  description = "Allows ${var.service} lambdas to retrieve secrets"
  policy      = data.aws_iam_policy_document.allow_secrets_doc.json
}

resource "aws_iam_role_policy_attachment" "allow_salesforce_ddb" {
  role       = module.loyalty_salesforce_lambda.lambda_iam_role_id
  policy_arn = aws_iam_policy.allow_ddb.arn
  depends_on = [module.loyalty_salesforce_lambda]
}

resource "aws_iam_role_policy_attachment" "allow_salesforce_secret_lookup" {
  role       = module.loyalty_salesforce_lambda.lambda_iam_role_id
  policy_arn = aws_iam_policy.allow_lambda_secret_lookup.arn
}

# ---------- SQS ---------------
resource "aws_iam_policy" "allow_sqs_queue" {
  name        = "sqs-${var.app_name}-${local.env}"
  description = "Allows ${var.service} lambdas to send/receive sqs queue"
  policy      = data.aws_iam_policy_document.queue_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "allow_salesforce_sqs_send" {
  role       = module.loyalty_salesforce_lambda.lambda_iam_role_id
  policy_arn = aws_iam_policy.allow_sqs_queue.arn
}
resource "aws_iam_role_policy_attachment" "allow_sqs_ddb" {
  role       = module.loyalty_sqs_lambda.lambda_iam_role_id
  policy_arn = aws_iam_policy.allow_ddb.arn
  depends_on = [module.loyalty_sqs_lambda]
}

resource "aws_iam_role_policy_attachment" "allow_sqs_secret_lookup" {
  role       = module.loyalty_sqs_lambda.lambda_iam_role_id
  policy_arn = aws_iam_policy.allow_lambda_secret_lookup.arn
}


# ---------- SNS ---------------
resource "aws_iam_policy" "allow_sns_publish" {
  name        = "sns-${var.app_name}-${local.env}"
  description = "Allows ${var.service} lambdas to publish to sns topic"
  policy      = data.aws_iam_policy_document.sns_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "allow_lambda_sns_send" {
  role       = module.loyalty_sqs_lambda.lambda_iam_role_id
  policy_arn = aws_iam_policy.allow_sns_publish.arn
}
