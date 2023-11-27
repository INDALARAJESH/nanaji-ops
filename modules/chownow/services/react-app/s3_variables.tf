variable "publish" {
  description = "Publish s3 lambda"
  default     = "false"
}

variable "filter_prefix" {
  description = "Filter_prefix for react-app build"
  default     = "build-"
}
variable "filter_suffix" {
  description = "Filter suffix for AWS S3 nofitication "
  default     = "index.html"
}

variable "cors_rule" {
  default = []
}
