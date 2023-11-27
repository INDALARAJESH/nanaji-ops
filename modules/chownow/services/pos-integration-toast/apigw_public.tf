# Module for public-facing API Gateway to process Toast Webhooks

resource "aws_api_gateway_rest_api" "webhook_api" {
  name = "${local.service}-public"
  body = templatefile("${path.module}/templates/webhook_api.json", {
    webhook-lambda-invoke-arn = aws_lambda_alias.webhook_alias.invoke_arn
  })
}

resource "aws_api_gateway_rest_api_policy" "webhook_api" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id
  policy      = data.aws_iam_policy_document.webhook_api.json
}

data "aws_iam_policy_document" "webhook_api" {
  statement {
    effect = "Deny"
    actions = [
      "execute-api:Invoke"
    ]
    resources = ["${aws_api_gateway_rest_api.webhook_api.execution_arn}/*/*/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.webhook_allowed_ip_ranges
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "execute-api:Invoke"
    ]
    resources = ["${aws_api_gateway_rest_api.webhook_api.execution_arn}/*/*/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# permission to api gateway to invoke the webhook lambda
resource "aws_lambda_permission" "api-gw" {
  statement_id  = "AllowToastWebhookExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.webhook.arn
  principal     = "apigateway.amazonaws.com"
  qualifier     = aws_lambda_alias.webhook_alias.name

  source_arn = "${aws_api_gateway_rest_api.webhook_api.execution_arn}/*/POST/v1/webhooks"
}
