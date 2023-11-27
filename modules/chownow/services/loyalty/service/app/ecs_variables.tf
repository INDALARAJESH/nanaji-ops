variable "container_port" {
  description = "ingress TCP port for container"
  default     = "8000"
}

variable "host_port" {
  description = "host TCP port for container"
  default     = "8000"
}

variable "container_protocol" {
  description = "protocol spoken on container_port"
  default     = "HTTP"
}

variable "ecs_service_desired_count" {
  description = "number of services to run per container"
  default     = "1"
}

variable "log_retention_in_days" {
  description = "number of days to retain log files"
  default     = "30"
}

variable "image_repository_arn" {
  description = "ECR repository_arn"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com/loyalty-service"
}

variable "dd_service_mapping" {
  description = "Datadog service mapping"
  default     = "pynamodb:loyalty-dynamodb,aws.sqs:sqs-memberships-queue,aws.monitoring:loyalty-service-monitoring,aws.secretsmanager:loyalty-service-secrets,cn_namespace:loyalty-service"
}
