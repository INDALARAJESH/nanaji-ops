resource "aws_iam_role" "pritunl_app" {
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

resource "aws_iam_instance_profile" "pritunl_app" {
  name = local.name
  path = "/ec2_profiles/"
  role = aws_iam_role.pritunl_app.name
}

resource "aws_iam_role_policy_attachment" "pritunl_app_ec2_ssm" {
  role       = aws_iam_role.pritunl_app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "pritunl_app" {
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
}

resource "aws_iam_role_policy_attachment" "pritunl_app" {
  role       = aws_iam_role.pritunl_app.name
  policy_arn = aws_iam_policy.pritunl_app.arn
}
