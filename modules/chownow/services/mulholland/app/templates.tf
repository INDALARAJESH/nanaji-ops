data "template_file" "mul_2fa_lambda_policy" {
  template = file("${path.module}/templates/mul_2fa_lambda_policy.json.tpl")

  vars = {
    aws_region         = var.aws_region
    aws_account_id     = var.aws_account_id
    account_table_name = "${var.mul_2fa_table_name}-${local.env}"
  }
}

data "template_file" "mul_assume_svc_role_policy" {
  template = file("${path.module}/templates/mul_assume_service_role_policy.json.tpl")

  vars = {
    aws_account_id = var.aws_account_id
    aws_region     = var.aws_region
    env            = local.env
  }
}

data "template_file" "mul_svc_role_policy" {
  template = file("${path.module}/templates/mul_service_role_policy.json.tpl")

  vars = {
    aws_account_id     = var.aws_account_id
    aws_region         = var.aws_region
    account_table_name = "${var.mul_2fa_table_name}-${local.env}"
  }
}

data "template_file" "mul_trust_policy" {
  template = file("${path.module}/templates/mul_trust_policy.json.tpl")

  vars = {
    aws_account_id = var.aws_account_id
  }
}
