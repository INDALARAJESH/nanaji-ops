data "template_file" "lambda_policy" {
  template = file("${path.module}/templates/lambda_policy.json.tpl")

  vars = {
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
    secrets_path   = "${local.env}/${local.app_name}/*"
    dd_api_key_arn = local.dd_api_key_arn
    table_name     = local.table_name
    kms_arn        = data.aws_kms_key.fbe.arn
  }
}
