### Default role/profile for ec2 instance
resource "aws_iam_role" "ec2_role" {
  name               = local.server_group
  path               = "/ec2_roles/${var.service}/"
  assume_role_policy = data.template_file.ec2_role.rendered

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.server_group }
  )
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = local.server_group
  path = "/ec2_profiles/${var.service}/"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
