resource "aws_iam_role" "lambda_role" {
  name               = var.lambda_name
  description        = var.lambda_description
  path               = "/lambda_roles/${var.service}/"
  assume_role_policy = data.template_file.lambda_assume_role.rendered

  tags = {
    Env         = var.env
    Lambda_Name = var.lambda_name
    Service     = var.service
  }
}

### Lambda Base Policy
resource "aws_iam_policy" "lambda_base" {
  name        = "${var.lambda_name}_lambda_base"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${var.lambda_name} basic functionality"
  policy      = data.template_file.lambda_base_policy.rendered
}

resource "aws_iam_policy_attachment" "lambda_base" {
  name       = "${var.lambda_name}_lambda_base_role_policy_attach"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_base.arn
}
