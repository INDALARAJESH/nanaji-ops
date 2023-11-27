resource "aws_iam_role" "app" {
  name               = "${var.service}-backup-role-${local.env}"
  path               = "/${local.env}/${var.service}/"
  assume_role_policy = data.template_file.backup_role.rendered

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-backup-role-${local.env}" }
  )
}

# Backup Policy ARN
resource "aws_iam_policy" "backup" {
  name   = "${var.service}-backup-${local.env}"
  path   = "/${local.env}/${var.service}/"
  policy = data.template_file.backup_policy.rendered
}

resource "aws_iam_role_policy_attachment" "backup" {
  role       = aws_iam_role.app.id
  policy_arn = aws_iam_policy.backup.arn
}

# Additional Policy
resource "aws_iam_role_policy" "addtl" {
  count = var.aux_iam_policy != "" ? 1 : 0

  name   = "${var.service}-backup-addtl-${local.env}"
  role   = aws_iam_role.app.id
  policy = var.aux_iam_policy
}
