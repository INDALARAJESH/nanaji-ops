variable "bucket_name" {
  description = "S3 bucket name"
}

variable "bucket_arn" {
  description = "S3 bucket arn"
}

variable "bucket_domain_name" {
  description = "S3 bucket domain name"
}

variable "price_class" {
  default = "PriceClass_100"
}

variable "aliases" {
  default = []
}

variable "viewer_protocol_policy" {
  default = "allow-all"
}

variable "lambda_function_association" {
  default = []
}

variable "custom_error_response" {
  default = []
}

variable "acm_certificate_arn" {
  description = "SSL certificate ARN"
}

variable "headers" {
  default = []
}
