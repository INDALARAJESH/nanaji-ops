variable "mul_2fa_integration_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.8"
}

variable "mul_2fa_integration_name" {
  description = "lambda name"
  default     = "mulholland-2fa-integration"
}

variable "mul_2fa_image_uri" {
  description = "lambda ECR image URI"
  default     = ""
}

variable "mul_2fa_integration_s3" {
  description = "boolean for enabling s3 artifacts for lambda"
  default     = false
}

variable "mul_2fa_integration_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "mul_2fa_integration_memory_size" {
  description = "lambda memory allocation"
  default     = 128
}

variable "mul_2fa_integration_cron" {
  description = "boolean for enabling lambda cron"
  default     = false
}

locals {
  mul_2fa_env_vars = {
    ENV             = local.env
    MUL_2FA_SNS_ARN = module.mul_2fa_sns.arn
  }
}
