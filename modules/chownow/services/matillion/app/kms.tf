resource "aws_kms_key" "matillion" {
  description = "Matillion KMS key"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.server_group,
    )
  )
}

resource "aws_kms_alias" "matillion" {
  name          = "alias/matillion-key"
  target_key_id = aws_kms_key.matillion.key_id
}
