# Supplemental 2FA policy
resource "aws_iam_policy" "mul_2fa_lambda_policy" {
  name        = "${var.mul_2fa_integration_name}_policy"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${var.mul_2fa_integration_name} specific functionality"
  policy      = data.template_file.mul_2fa_lambda_policy.rendered
}

resource "aws_iam_role_policy_attachment" "mul_2fa_lambda_policy_attachment" {
  role       = module.mulholland_2fa_integration_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.mul_2fa_lambda_policy.arn
}

# Mulholland assume service role
module "user_svc_assume_mulholland" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.1"

  env               = local.env
  service           = "${var.service}_assume"
  create_access_key = true
  user_policy       = data.template_file.mul_assume_svc_role_policy.rendered
}

# mulholland on-prem pipeline role
resource "aws_iam_role" "mulholland_on_prem_role" {
  name               = "${var.service}-on-prem-${var.env}"
  description        = "Role for on prem resources to assume"
  assume_role_policy = data.template_file.mul_trust_policy.rendered

  tags = local.common_tags
}

resource "aws_iam_policy" "mul_svc_role_policy" {
  name        = "${var.service}-on-prem-policy-${var.service}"
  description = "Policy to give ${var.service} specific functionality"
  policy      = data.template_file.mul_svc_role_policy.rendered
}

resource "aws_iam_role_policy_attachment" "mul_svc_role_policy_attachment" {
  role       = aws_iam_role.mulholland_on_prem_role.name
  policy_arn = aws_iam_policy.mul_svc_role_policy.arn
}
