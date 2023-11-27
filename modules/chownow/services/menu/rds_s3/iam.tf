resource "aws_iam_role_policy_attachment" "menu_rds_s3_attachment" {
  role       = aws_iam_role.menu_rds_s3_role.name
  policy_arn = aws_iam_policy.menu_rds_s3_policy.arn
}
resource "aws_iam_role" "menu_rds_s3_role" {
  name = "menu-rds-s3-role-${local.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "menu-rds-s3-role-${local.env}"
  }
}

resource "aws_iam_policy" "menu_rds_s3_policy" {
  name = "menu-rds-s3-policy-${local.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_name}/*",
          "arn:aws:s3:::${local.s3_bucket_name}"
        ]
      }
    ]
  })
}

resource "aws_rds_cluster_role_association" "menu_rds_s3_role_association" {
  db_cluster_identifier = data.aws_rds_cluster.menu_rds.id
  feature_name          = ""
  role_arn              = aws_iam_role.menu_rds_s3_role.arn
}
