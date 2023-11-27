data "template_file" "codebuild-policy-document" {
  template = file("${path.module}/templates/codebuild-policy.json.tpl")

  vars = {
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
    repository     = "${var.service}-${local.env}"
    environment    = local.env
    service        = var.service
  }
}
