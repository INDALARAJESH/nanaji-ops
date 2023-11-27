data "template_file" "lambda_assume_role" {
  template = file("${path.module}/templates/lambda_assume_role.json.tpl")
}

data "template_file" "lambda_base_policy" {
  template = file("${path.module}/templates/lambda_base_policy.json.tpl")

  vars = {
    artifact_bucket_name = local.s3_bucket
  }
}
