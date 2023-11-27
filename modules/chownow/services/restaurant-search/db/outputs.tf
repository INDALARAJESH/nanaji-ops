output "search_endpoint" {
  description = "URL that search database can be accessed at"
  value       = module.search_db.search_endpoint
}

output "kibana_endpoint" {
  description = "URL that Kibana can be accessed at"
  value       = module.search_db.kibana_endpoint
}

output "user_id" {
  description = "AWS access key ID for OpenSearch user"
  value       = module.search_db.aws_access_key_id
}

output "user_secret" {
  description = "AWS secret access key for OpenSearch user"
  value       = module.search_db.aws_secret_access_key
}
