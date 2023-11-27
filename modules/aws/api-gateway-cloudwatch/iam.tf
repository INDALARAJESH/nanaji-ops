resource "aws_api_gateway_account" "api" {
  cloudwatch_role_arn = var.create_iam == 1 ? aws_iam_role.cloudwatch[0].arn : data.aws_iam_role.cloudwatch[0].arn
}

resource "aws_iam_role" "cloudwatch" {
  count = var.create_iam
  name  = "api-gateway-cloudwatch-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  count = var.create_iam
  name  = "api-gateway-cloudwatch-${var.env}"
  role  = aws_iam_role.cloudwatch[count.index].id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
