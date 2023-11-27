resource "aws_iam_role" "service" {
  name               = local.name
  assume_role_policy = file("${path.module}/files/assume_role.json")

  tags = merge(local.common_tags, { "Name" = local.name })
}


data "aws_iam_policy_document" "service" {
  statement {
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.pm_status.arn]
  }
}

resource "aws_iam_policy" "service" {
  name        = local.name
  description = "service policy for ${local.name}"
  path        = "/${local.env}/${var.service}/"
  policy      = data.aws_iam_policy_document.service.json

  tags = merge(local.common_tags, { "Name" = local.name })
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = aws_iam_role.service.id
  policy_arn = aws_iam_policy.service.arn
}


# based on built-in AmazonSSMServiceRolePolicy
# https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/policies/details/arn%3Aaws%3Aiam%3A%3Aaws%3Apolicy%2Faws-service-role%2FAmazonSSMServiceRolePolicy?section=policy_permissions
resource "aws_iam_policy" "aws_ssm_builtin" {
  name        = "builtin-${local.name}"
  description = "built-in ssm service policy for ${local.name}"
  path        = "/${local.env}/${var.service}/"
  policy      = file("${path.module}/files/ssm_service_policy.json")

  tags = merge(local.common_tags, { "Name" = "builtin-${local.name}" })
}

resource "aws_iam_role_policy_attachment" "aws_ssm_builtin" {
  role       = aws_iam_role.service.id
  policy_arn = aws_iam_policy.aws_ssm_builtin.arn
}
