output "key_arn_main" {
  value       = aws_kms_key.key_main.arn
  description = "Key ARN"
}

output "key_id_main" {
  value       = aws_kms_key.key_main.key_id
  description = "Key ID"
}

output "alias_arn_main" {
  value       = aws_kms_alias.key_alias_main.arn
  description = "Alias ARN"
}

output "alias_name_main" {
  value       = aws_kms_alias.key_alias_main.name
  description = "Alias name"
}
