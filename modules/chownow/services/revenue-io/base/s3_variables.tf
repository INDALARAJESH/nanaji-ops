variable "enable_bucket_revenue_io" {
  description = "on/off toggle for revenue.io S3 bucket creation"
  default     = 0
}

variable "revenue_io_bucket_name" {
  description = "bucket name for policy template"
  default     = "cn-revenue-io-data"
}
