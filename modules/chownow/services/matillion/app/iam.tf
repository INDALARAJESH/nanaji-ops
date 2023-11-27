data "aws_iam_policy_document" "matillion" {
  statement {
    effect = "Allow"
    actions = [
      "sns:*",
      "kms:List*",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
    ]
    resources = ["arn:aws:kms:us-east-1:475330587555:key/867cab01-8f52-4968-ab51-bd8f6f0c3c6f"]
  }

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets"
    ]
    resources = ["arn:aws:secretsmanager:us-east-1:475330587555:secret:data/matillion",
    "arn:aws:secretsmanager:us-east-1:475330587555:secret:data/matillion/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:*Object",
    ]
    resources = ["arn:aws:s3:::mp-forwarding-cn-quarantine-${local.env}",
    "arn:aws:s3:::mp-forwarding-cn-quarantine-${local.env}/*"]
  }
}

resource "aws_iam_policy" "matillion" {
  name        = "data_tools_policy"
  path        = "/"
  description = "Data tools policy"

  policy = data.aws_iam_policy_document.matillion.json
}

data "aws_iam_policy_document" "s3" {

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::cn-production-data-eng",
      "arn:aws:s3:::cn-development-data-eng"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::cn-production-data-eng/*",
      "arn:aws:s3:::cn-development-data-eng/*"
    ]
  }
}

resource "aws_iam_policy" "s3" {
  name        = "data_s3_policy"
  path        = "/"
  description = "Data S3 policy"

  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_role" "matillion" {
  name               = "${local.server_group}-extended"
  path               = "/ec2_roles/${var.service}/"
  assume_role_policy = data.template_file.ec2_role.rendered

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.server_group,
    )
  )
}

resource "aws_iam_role_policy_attachment" "ssmm" {
  role       = aws_iam_role.matillion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "matillion" {
  role       = aws_iam_role.matillion.name
  policy_arn = aws_iam_policy.matillion.arn
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.matillion.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_instance_profile" "matillion" {
  name = "${local.server_group}-extended"
  path = "/ec2_profiles/${var.service}/"
  role = aws_iam_role.matillion.name
}
