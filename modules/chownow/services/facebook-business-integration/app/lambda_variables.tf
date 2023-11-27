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


variable "api_gateway_path_prefix" {
  description = "URI path prefix for api gateway and lambda integration"
  default     = "fbe"
}

variable "lambda_memory_size" {
  description = "lambda memory allocation"
  default     = 256
}


locals {
  access_log_settings = [{
    destination_arn = aws_cloudwatch_log_group.gateway.arn
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "caller" : "$context.identity.caller", "user" : "$context.identity.user", "requestTime" : "$context.requestTime", "httpMethod" : "$context.httpMethod", "resourcePath" : "$context.resourcePath", "status" : "$context.status", "protocol" : "$context.protocol", "responseLength" : "$context.responseLength", "userAgent" : "$context.identity.userAgent", "integrationError" : "$context.integration.error", "sourceIp" : "$context.identity.sourceIp", "routeKey" : "$context.routeKey", "path" : "$context.path" })
  }]

  domain_names = [
    "${var.subdomain_name}.${local.domain_name}",
    "${var.subdomain_name}-origin.${local.domain_name}"
  ]
}
