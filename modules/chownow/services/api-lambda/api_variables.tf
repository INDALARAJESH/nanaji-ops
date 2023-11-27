variable "api_id" {
  description = "Id of REST API gateway"
}

variable "name" {
  description = "name of API gateway and lambda"
}

variable "service" {
  description = "name of service used in naming the lambda"
}

variable "lambda_description" {
  description = "Description of lambda"
  default     = "Default description"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
}

variable "route53_zone_id" {
  description = "Route 53 zone id"
  default     = ""
}

variable "path_prefix" {
  description = "HTTP path prefix. ie '/fbe' "
  default     = ""
}

variable "lambda_s3" {
  description = "use S3 for lambda code"
  default     = true
}

variable "lambda_ecr" {
  description = "use ECR for lambda code"
  default     = false
}

variable "lambda_image_uri" {
  description = "lambda ECR image URI"
  default     = ""
}

variable "access_log_settings" {
  description = "Cloudwatch access log settings"
  type        = list(object({ destination_arn = string, format = string }))
  default     = []
}
