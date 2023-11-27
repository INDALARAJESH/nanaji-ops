data "aws_iam_role" "cloudwatch" {
  count = var.create_iam == 0 ? 1 : 0
  name  = "api-gateway-cloudwatch-${var.env}"
}
