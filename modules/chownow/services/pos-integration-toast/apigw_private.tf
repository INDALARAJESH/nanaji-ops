resource "aws_api_gateway_rest_api" "private_api" {
  name = "${local.service}-private"

  body = templatefile("${path.module}/templates/private_api.json", {
    get-order-prices-lambda-invoke-arn         = module.get_order_prices.lambda_alias_invoke_arn
    get-restaurant-lambda-invoke-arn           = module.get_restaurant.lambda_alias_invoke_arn
    get-restaurant-locations-lambda-invoke-arn = module.get_restaurant_locations.lambda_alias_invoke_arn
    get-restaurant-errors-lambda-invoke-arn    = module.get_restaurant_errors.lambda_alias_invoke_arn
    patch-restaurant-lambda-invoke-arn         = module.patch_restaurant.lambda_alias_invoke_arn
    post-authorization-url-lambda-invoke-arn   = module.post_authorization_url.lambda_alias_invoke_arn
    post-order-lambda-invoke-arn               = module.post_order.lambda_alias_invoke_arn
  })

  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = var.source_vpc_endpoint_ids
  }
}

resource "aws_api_gateway_rest_api_policy" "private_api" {
  rest_api_id = aws_api_gateway_rest_api.private_api.id
  policy      = data.aws_iam_policy_document.private_api.json
}

data "aws_iam_policy_document" "private_api" {
  statement {
    effect = "Deny"
    actions = [
      "execute-api:Invoke"
    ]
    resources = ["${aws_api_gateway_rest_api.private_api.execution_arn}/*/*/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpce"
      values   = var.source_vpc_endpoint_ids
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "execute-api:Invoke"
    ]
    resources = ["${aws_api_gateway_rest_api.private_api.execution_arn}/*/*/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
