variable "lambda_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.9"
}

variable "api_gateway_event_handler_image_uri" {
  description = "API gateway event handler lambda ECR image URI"
}

variable "presigned_url_lambda_image_uri" {
  description = "Presigned URL lambda ECR image URI"
}

variable "event_bridge_event_handler_image_uri" {
  description = "EventBridge event handler lambda ECR image URI"
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

variable "lambda_cron" {
  description = "boolean for enabling lambda cron"
  default     = false
}

# Set app handler in `DD_LAMBDA_HANDLER` env var.
# https://docs.datadoghq.com/serverless/installation/python/?tab=containerimage#configure-the-function
variable "lambda_handler" {
  description = "entry point of the lambda"
  default     = "datadog_lambda.handler.handler"
}

variable "sfdc_domain_name" {
  description = "SFDC domain name"
  default     = "chownow--cnfull.sandbox.my.salesforce.com"
}

variable "sfdc_user_name" {
  description = "SFDC user name"
  default     = "bizsystemsteam@chownow.com.onboardingservice.cnfull"
}

variable "sfdc_client_id" {
  description = "SFDC client ID"
  default     = "3MVG9MwiKwcReohzLp4a7LNdHbYKmEgbvNTeaThKYJ7u1M2ljm05CcpD574ZUC311HeBZ5Gwi6dGKOZkjAxdA"
}
