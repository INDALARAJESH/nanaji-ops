### Lambda Policy
### Lambda Execution Role -- https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html

data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = "secret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      format(
        "arn:aws:secretsmanager:%s:%s:secret:%s/%s/*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        local.env,
        local.app_name
      ),
      format(
        "%s*", data.aws_secretsmanager_secret.dd_api_key.arn
      )
    ]
  }

  statement {
    sid    = "KMS"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt"
    ]
    resources = [
      format(
        "%s", data.aws_kms_key.pos_square.arn
      )
    ]
  }

  statement {
    sid    = "StepFunctionsStartExecution"
    effect = "Allow"
    actions = [
      "states:StartExecution",
    ]
    resources = [
      # arn:aws:states:us-east-1:816344209152:stateMachine:pos-square-integration-order-dev
      format(
        "arn:aws:states:%s:%s:stateMachine:%s-*-%s",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        local.app_name,
        local.env
      ),
    ]
  }

  statement {
    sid    = "StepFunctionsDescribeExecution"
    effect = "Allow"
    actions = [
      "states:DescribeExecution"
    ]
    resources = [
      # arn:aws:states:us-east-1:816344209152:execution:pos-square-integration-order-dev:4b093cc390ef4cbdb85808cb30549f51
      format(
        "arn:aws:states:%s:%s:execution:%s-*-%s:*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        local.app_name,
        local.env
      ),
    ]
  }

  statement {
    sid    = "SQS"
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:GetQueueUrl"
    ]
    resources = [
      format("%s", module.sqs_success_queue.sqs_queue_arn),
      format("%s", module.sqs_failure_queue.sqs_queue_arn)
    ]
  }

  statement {
    sid    = "XRay"
    effect = "Allow"
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda" {
  name        = format("%s_lambda", local.app_name)
  path        = format("/lambda_policies/%s/", local.app_name)
  description = format("Policy to give %s specific functionality", local.app_name)
  policy      = data.aws_iam_policy_document.lambda.json
}
