output "bucket_name" {
  description = "The name of the bucket"
  value       = element(concat(aws_s3_bucket_policy.bucket.*.id, aws_s3_bucket.bucket.*.id, tolist([])), 0)
}

output "bucket_arn" {
  description = "The ARN of the bucket formatted as arn:aws:s3:::bucketname"
  value       = element(concat(aws_s3_bucket.bucket.*.arn, tolist([])), 0)
}

output "bucket_domain_name" {
  description = "The bucket domain name formatted as bucketname.s3.amazonaws.com"
  value       = element(concat(aws_s3_bucket.bucket.*.bucket_domain_name, tolist([])), 0)
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = element(concat(aws_s3_bucket.bucket.*.bucket_regional_domain_name, tolist([])), 0)
}

output "bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region"
  value       = element(concat(aws_s3_bucket.bucket.*.hosted_zone_id, tolist([])), 0)
}

output "bucket_region" {
  description = "The bucket's region"
  value       = element(concat(aws_s3_bucket.bucket.*.region, tolist([])), 0)
}

output "bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = element(concat(aws_s3_bucket.bucket.*.website_endpoint, tolist([])), 0)
}

output "bucket_website_domain" {
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. "
  value       = element(concat(aws_s3_bucket.bucket.*.website_domain, tolist([])), 0)
}
