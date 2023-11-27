resource "aws_ssoadmin_permission_set" "sso" {
  name             = var.permission_set_name
  description      = "${var.permission_set_name} Permission Set"
  instance_arn     = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  session_duration = var.session_duration
}

resource "aws_ssoadmin_managed_policy_attachment" "sso" {
  instance_arn       = aws_ssoadmin_permission_set.sso.instance_arn
  managed_policy_arn = var.iam_policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.sso.arn
}
