# Jumpbox Policies
resource "aws_iam_role" "jumpbox-ssm" {
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

resource "aws_iam_instance_profile" "jumpbox-ssm-profile" {
  name = local.name
  path = "/ec2_profiles/"
  role = aws_iam_role.jumpbox-ssm.name
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.jumpbox-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "teleport_dynamic_policy" {
  role       = aws_iam_role.jumpbox-ssm.name
  policy_arn = data.aws_iam_policy.teleport_dynamic_policy.arn
}

resource "aws_iam_role_policy_attachment" "teleport_connect_policy" {
  role       = aws_iam_role.jumpbox-ssm.name
  policy_arn = data.aws_iam_policy.teleport_connect_policy.arn
}

resource "aws_iam_policy" "jumpbox" {
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
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.threatstack_key_secret_name}-*",
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.sysdig_access_key_secret_name}-*",
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.teleport_selfsigned_secret_name}-*"
       ]
      }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "jumpbox" {
  role       = aws_iam_role.jumpbox-ssm.name
  policy_arn = aws_iam_policy.jumpbox.arn
}
