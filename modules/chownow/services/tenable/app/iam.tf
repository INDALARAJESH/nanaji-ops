# IAM Policies
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tenable-ops-ro" {
  name               = "tenable-${var.vpc_name}-ro"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_instance_profile" "tenable-ops-ro-profile" {
  name = aws_iam_role.tenable-ops-ro.id
  role = aws_iam_role.tenable-ops-ro.name
}

resource "aws_iam_role_policy_attachment" "tenable-ops-ro-ec2-ro" {
  role       = aws_iam_role.tenable-ops-ro.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
