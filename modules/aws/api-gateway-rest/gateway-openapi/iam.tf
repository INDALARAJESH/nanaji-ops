data "aws_iam_policy_document" "api_gw_resource_policy" {

  /*
    Please check the README notes regarding these resource policies
  */
  statement {
    effect = "Deny"
    actions = [
      "execute-api:Invoke"
    ]
    resources = [
      # "execute-api:/{{stageNameOrWildcard*}}/{{httpVerbOrWildcard*}}/{{resourcePathOrWildcard*}}"
      # format("execute-api:/*") triggers "arn:aws:execute-api:region:account-id:apigw-id/*" -> "execute-api:/*"
      format("arn:aws:execute-api:%s:%s:%s/*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        aws_api_gateway_rest_api.api.id
      )
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.resource_policy_allow_cidr_block_list
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "execute-api:Invoke"
    ]
    resources = [
      # "execute-api:/{{stageNameOrWildcard*}}/{{httpVerbOrWildcard*}}/{{resourcePathOrWildcard*}}"
      # format("execute-api:/*") triggers "arn:aws:execute-api:region:account-id:apigw-id/*" -> "execute-api:/*"
      format("arn:aws:execute-api:%s:%s:%s/*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        aws_api_gateway_rest_api.api.id
      )
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
