output "bucket_name" {
  value = aws_s3_bucket.cloudflare_logs.id
}

output "bucket_arn" {
  value = aws_s3_bucket.cloudflare_logs.arn
}
