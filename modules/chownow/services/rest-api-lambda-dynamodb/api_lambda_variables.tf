variable "api_gateway_name" {
  description = "Name of REST API gateway"
}

variable "domain_names" {
  description = "Custom domains names to map with stage and api"
  default     = []
}

variable "lambda_description" {
  description = "Description of lambda"
  default     = "Default description"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  default     = ""
}

variable "lambda_env_variables" {
  description = "Lambda environment variables map"
  type        = map(string)
  default     = {}
}

variable "path_prefix" {
  description = "HTTP path prefix. ie 'fbe' "
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
