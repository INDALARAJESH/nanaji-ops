output "endpoint" {
  description = "the database's address"
  value       = aws_rds_cluster.db.endpoint
}

output "cluster_id" {
  value = aws_rds_cluster.db.id
}

output "cluster_identifier" {
  value = aws_rds_cluster.db.cluster_identifier
}

output "pgmaster_password" {
  value     = aws_rds_cluster.db.master_password
  sensitive = true
}
