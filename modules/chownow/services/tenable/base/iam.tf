# https://docs.tenable.com/vulnerability-management/Content/Settings/cloud-connectors/AWS/ConfigureAWSKeylessDiscovery.htm

resource "aws_iam_role_policy_attachment" "tenableio_connector_attachment" {
  role       = aws_iam_role.tenableio_connector_role.name
  policy_arn = aws_iam_policy.tenableio_connector_policy.arn
}
resource "aws_iam_role" "tenableio_connector_role" {
  name = "tenableio-connector"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::012615275169:role/keyless_connector_role"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "b9dfc8b1-8310-4c4c-afe2-9ff31a60f5a3"
          }
        }
      }
    ]
  })

  tags = {
    Name = "tenableio-connector-role"
  }
}

resource "aws_iam_policy" "tenableio_connector_policy" {
  name        = "tenableio-connector-policy"
  description = "tenableio-connector"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudtrail:LookupEvents",
          "organizations:ListAccounts",
          "ec2:DescribeInstances",
          "cloudtrail:ListTags",
          "cloudtrail:GetTrailStatus",
          "cloudtrail:GetEventSelectors",
          "cloudtrail:DescribeTrails"
        ]
        Resource = "*"
      }
    ]
  })
}

