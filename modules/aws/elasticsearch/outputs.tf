output "search_endpoint" {
  description = "URL that search database can be accessed at"
  value       = aws_elasticsearch_domain.es.endpoint
}

output "kibana_endpoint" {
  description = "URL that Kibana can be accessed at"
  value       = aws_elasticsearch_domain.es.kibana_endpoint
}

output "aws_secret_access_key" {
  description = "IAM user credentials"
  value       = aws_iam_access_key.es.secret
}

output "aws_access_key_id" {
  description = "IAM user credentials"
  value       = aws_iam_access_key.es.id
}

output "aws_secret_access_key_admin_ro" {
  description = "IAM user credentials"
  value       = aws_iam_access_key.admin_ro.secret
}

output "aws_access_key_id_admin_ro" {
  description = "IAM user credentials"
  value       = aws_iam_access_key.admin_ro.id
}
