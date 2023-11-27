output "address" {
  description = "the database's address"
  value       = aws_db_instance.db.address
}

output "db_id" {
  value = aws_db_instance.db.id
}

output "db_identifier" {
  value = aws_db_instance.db.identifier
}

output "pgmaster_password" {
  value     = aws_db_instance.db.password
  sensitive = true
}

