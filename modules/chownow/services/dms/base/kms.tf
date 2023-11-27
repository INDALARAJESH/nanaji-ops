resource "aws_kms_alias" "dms" {
  name          = "alias/dms-kms"
  target_key_id = aws_kms_key.dms.id
}

resource "aws_kms_key" "dms" {
  description = "delivery-management-service kms key for OPS-3372"
}

output "kms_key_id" {
  value       = aws_kms_key.dms.key_id
  description = "kms key id used in dms-app ECS task definition templating"
}
