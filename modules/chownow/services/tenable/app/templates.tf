# Templates
data "template_file" "user_data" {
  template = file("${path.module}/templates/tenable_user_data.tpl")

  vars = {
    tenable_env  = var.vpc_name,
    tenable_key  = data.aws_secretsmanager_secret_version.tenable_api_token.secret_string,
    tenable_role = aws_iam_role.tenable-ops-ro.id,
  }
}
