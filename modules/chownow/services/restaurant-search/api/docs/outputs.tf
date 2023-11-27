output "docs_domain_name" {
  description = "URL that can be used to access API Documentation"
  value       = module.docs_s3_bucket.bucket_website_domain
}
