resource "aws_ssoadmin_account_assignment" "sso" {
  instance_arn       = data.aws_ssoadmin_permission_set.sso.instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.sso.arn

  principal_id   = local.principal_id
  principal_type = local.principal_type

  target_id   = var.account_id
  target_type = "AWS_ACCOUNT"
}
