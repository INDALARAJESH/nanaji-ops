resource "aws_iam_user" "human" {
  name = local.username
  path = "/${local.env}/users/humans/"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.username }
  )
}

resource "aws_iam_user_group_membership" "human" {
  user   = aws_iam_user.human.name
  groups = var.iam_groups
}
