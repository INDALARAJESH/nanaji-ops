data "template_file" "lambda_policy" {
  template = file("${path.module}/templates/lambda_policy.json.tpl")

  vars = {
    aws_region           = data.aws_region.current.name
    aws_account_id       = data.aws_caller_identity.current.account_id
    channels_bucket_name = "cn-${var.service}-${local.env}"
    nextdoor_bucket_name = "chownow-channels-nextdoor-${local.env}"
    dd_api_key_arn       = local.dd_api_key_arn
    secrets_path         = "${local.env}/${var.service}/*"
  }
}
