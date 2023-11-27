resource "aws_iam_role" "ec2" {
  name = local.name
  path = "/ec2_roles/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = local.name
  path = "/ec2_profiles/"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "base" {
  name = "${local.name}-base"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
       "Effect": "Allow",
       "Action": ["secretsmanager:GetSecretValue"],
       "Resource": [
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.dd_api_key_secret_name}-*",
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.threatstack_key_secret_name}-*",
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/backup/encryption_key-*",
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/backup/mongobackup-*"
       ]
      },
       {
       "Effect": "Allow",
       "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
       ],
       "Resource": [
        "arn:aws:s3:::cn-backup-${local.env}/services/${var.service}/*",
        "arn:aws:s3:::cn-backup-${local.env}/services/${var.service}"
       ]
      }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_base" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.base.arn
}
