data "template_file" "iam_policy_cloudflare" {
  template = file("${path.module}/templates/iam_policy_cloudflare.json.tpl")

  vars = {
    aws_account_number = var.cf_aws_account_number
    aws_user           = var.cf_aws_user
    s3_bucket          = local.s3_bucket_name
  }
}
