data "aws_iam_policy_document" "states_assume_role" {
  statement {
    sid     = "StatesAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_invoke" {
  statement {
    sid    = "StatesInvokeLambda"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      # arn:aws:lambda:us-east-1:012345678912:function:name-service*env[:alias]
      format(
        "arn:aws:lambda:%s:%s:function:%s-%s*%s*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        var.name,
        var.service,
        local.env
      )
    ]
  }
}

resource "aws_iam_policy" "lambda_invoke" {
  name   = format("%s_lambda", var.step_function_name)
  path   = format("/states_policies/%s/", var.step_function_name)
  policy = data.aws_iam_policy_document.lambda_invoke.json
}

resource "aws_iam_role_policy_attachment" "lambda_invoke" {
  role       = aws_iam_role.step_function.name
  policy_arn = aws_iam_policy.lambda_invoke.arn
}

data "aws_iam_policy_document" "sqs_access" {
  count = var.iam_sqs_arns != [] ? 1 : 0
  statement {
    sid    = "SQS"
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:GetQueueUrl"
    ]
    resources = var.iam_sqs_arns
  }
}

resource "aws_iam_policy" "sqs_access" {
  count  = var.iam_sqs_arns != [] ? 1 : 0
  name   = format("%s_sqs_access", var.step_function_name)
  path   = format("/states_policies/%s/", var.step_function_name)
  policy = data.aws_iam_policy_document.sqs_access[0].json
}

resource "aws_iam_role_policy_attachment" "sqs_access" {
  count      = var.iam_sqs_arns != [] ? 1 : 0
  role       = aws_iam_role.step_function.name
  policy_arn = aws_iam_policy.sqs_access[0].arn
}

resource "aws_iam_role_policy_attachment" "xray_writeonly" {
  role       = aws_iam_role.step_function.name
  policy_arn = format("arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess")
}

resource "aws_iam_role" "step_function" {
  name               = format("%s-step-functions-role", var.step_function_name)
  assume_role_policy = data.aws_iam_policy_document.states_assume_role.json
}
