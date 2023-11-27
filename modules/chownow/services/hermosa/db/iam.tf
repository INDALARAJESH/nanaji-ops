# This role is to allow Hermosa RDS to interact with an S3 bucket created by Menu service

resource "aws_iam_role_policy_attachment" "hermosa_rds_s3_attachment" {
  role       = aws_iam_role.hermosa_rds_s3_role.name
  policy_arn = aws_iam_policy.hermosa_rds_s3_policy.arn
}

resource "aws_iam_role" "hermosa_rds_s3_role" {
  name = local.iam_role_name

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
    Name = local.iam_role_name
  }
}

resource "aws_iam_policy" "hermosa_rds_s3_policy" {
  name = local.iam_policy_name

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
          "arn:aws:s3:::${var.menu_s3_bucket_name}/*",
          "arn:aws:s3:::${var.menu_s3_bucket_name}"
        ]
      }
    ]
  })
}

resource "aws_rds_cluster_role_association" "hermosa_rds_s3_role_association" {
  db_cluster_identifier = module.db_cluster.cluster_identifier
  feature_name          = ""
  role_arn              = aws_iam_role.hermosa_rds_s3_role.arn
}
