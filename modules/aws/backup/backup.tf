resource "aws_backup_vault" "app" {
  name = "${var.service}-vault-${local.env}"
}

resource "aws_backup_plan" "app" {
  name = "${var.service}-backup-${local.env}"

  rule {
    rule_name         = "${var.service}-backup-${local.env}"
    target_vault_name = aws_backup_vault.app.name
    schedule          = var.schedule

    lifecycle {
      delete_after = var.lifecycle_days
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-${local.env}" }
  )
}

resource "aws_backup_selection" "app" {
  plan_id      = aws_backup_plan.app.id
  name         = "${var.service}-backup-${local.env}"
  iam_role_arn = aws_iam_role.app.arn

  resources = var.backup_arn
}
