data "template_file" "mul_notifications_lambda_policy" {
  template = file("${path.module}/templates/mul_notifications_lambda_policy.json.tpl")

  vars = {
    aws_region     = var.aws_region
    aws_account_id = var.aws_account_id
  }
}

data "template_file" "mul_notifications_svc_role_policy" {
  template = file("${path.module}/templates/mul_notifications_svc_role_policy.json.tpl")

  vars = {
    aws_account_id = var.aws_account_id
    aws_region     = var.aws_region
    env            = local.env
  }
}
