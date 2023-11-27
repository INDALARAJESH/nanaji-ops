resource "aws_iam_user" "service" {
  name = local.username
  path = local.path

  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({
      Name = local.username
    })
  )
}

resource "aws_iam_user_policy" "service" {
  name   = "${var.service}-service-user-policy-${local.env}"
  user   = aws_iam_user.service.name
  policy = var.user_policy
}

resource "aws_iam_access_key" "service" {
  count = var.create_access_key
  user  = aws_iam_user.service.name
}
