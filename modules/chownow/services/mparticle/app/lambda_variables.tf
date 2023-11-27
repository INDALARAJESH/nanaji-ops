variable "lambda_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.7"
}

variable "lambda_image_uri" {
  description = "lambda ECR image URI"
  default     = ""
}

variable "lambda_s3" {
  description = "boolean for enabling s3 artifacts for lambda"
  default     = false
}

variable "lambda_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "lambda_memory_size" {
  description = "lambda memory allocation"
  default     = 256
}
