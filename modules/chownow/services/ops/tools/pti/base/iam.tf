### Default role/profile for ec2 instance
resource "aws_iam_role" "ec2_role" {
  name               = local.name
  path               = "/ec2_roles/${var.service}/"
  assume_role_policy = file("${path.module}/templates/ec2_role.json.tpl")

  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({
      "Name" = local.name
    })
  )
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = local.name
  path = "/ec2_profiles/${var.service}/"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
