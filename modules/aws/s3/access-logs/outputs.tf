output "bucket_id" {
  value = aws_s3_bucket.s3_access_logs.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_access_logs.arn
}
