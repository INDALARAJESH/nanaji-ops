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

  tags = merge(local.common_tags, { "Name" = local.name })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = local.name
  path = "/ec2_profiles/"
  role = aws_iam_role.ec2.name

  tags = merge(local.common_tags, { "Name" = local.name })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "ec2" {
  name = local.name

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
       "Effect": "Allow",
       "Action": ["secretsmanager:GetSecretValue"],
       "Resource": [
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.dd_api_key_secret_name}-*",
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.threatstack_key_secret_name}-*"
       ]
      }
   ]
}
EOF

  tags = merge(local.common_tags, { "Name" = local.name })
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2.arn
}
