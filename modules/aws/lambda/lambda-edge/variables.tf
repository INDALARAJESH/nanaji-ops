variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "env" {
  description = "which stage does this live in"
  default     = "CHANGETHEENV"
}

variable "service" {
  description = "unique service name"
  default     = "CHANGETHESERVICE"
}

variable "domain" {
  description = "domain to use for lambda"
  default     = "chownow.com"
}

variable "s3_bucket" {
  description = "Bucket for lambda package"
  default     = ""
}

locals {
  s3_bucket = "cn-${var.env}-repo"
  s3_key    = "lambdas/${var.service}/${var.lambda_name}.zip"
}
