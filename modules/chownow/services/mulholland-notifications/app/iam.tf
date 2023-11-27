resource "aws_iam_policy" "mul_notifications_lambda_policy" {
  name        = "${var.mul_notifications_slack_name}_policy"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${var.mul_notifications_slack_name} specific functionality"
  policy      = data.template_file.mul_notifications_lambda_policy.rendered
}

resource "aws_iam_role_policy_attachment" "mul_notifications_lambda_policy_attachment" {
  role       = module.mul_notifications_slack_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.mul_notifications_lambda_policy.arn
}

module "user_svc_mulholland_notifications" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.1"

  env               = local.env
  service           = var.service
  create_access_key = true
  user_policy       = data.template_file.mul_notifications_svc_role_policy.rendered
}
