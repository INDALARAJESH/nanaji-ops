resource "aws_iam_role" "lambda_role" {
  name               = local.lambda_classification
  description        = var.lambda_description
  path               = "/lambda_policies/${var.service}/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(
    local.common_tags,
    var.extra_tags
  )

  lifecycle {
    create_before_destroy = false
  }
}

### Lambda Base Policy
resource "aws_iam_policy" "lambda_base" {
  name        = "${local.lambda_classification}_lambda_base"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${local.lambda_classification} basic functionality"
  policy      = data.aws_iam_policy_document.lambda_base_policy_ecr.json
}

resource "aws_iam_policy_attachment" "lambda_base" {
  name       = "${local.lambda_classification}_lambda_base_role_policy_attach"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_base.arn
}

### Lambda VPC policy
resource "aws_iam_role_policy_attachment" "lambda_docs_vpc" {
  count      = var.lambda_vpc_subnet_ids != [] ? 1 : 0
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

### Lambda Optional Policy attachment
resource "aws_iam_role_policy_attachment" "lambda_optional" {
  count      = var.lambda_optional_policy_enabled ? 1 : 0
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.lambda_optional_policy_arn
}