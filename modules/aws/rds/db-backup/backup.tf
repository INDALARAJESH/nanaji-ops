resource "aws_kms_key" "backup" {
  description = "KMS Key used for cross-region automated backups"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_kms_alias" "backup" {
  name          = "alias/${local.name}"
  target_key_id = aws_kms_key.backup.key_id
}


resource "aws_db_instance_automated_backups_replication" "service" {
  for_each = var.databases

  source_db_instance_arn = each.value.arn
  kms_key_id             = aws_kms_key.backup.arn
  retention_period       = each.value.retention
}
