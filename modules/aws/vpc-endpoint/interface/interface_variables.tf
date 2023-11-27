variable "name" {
  description = "Easily identifiable name for tagging"
  type        = string
}

variable "service_name" {
  description = "The service that you are connecting to (i.e. ec2 or execute-api)"
  type        = string

  # aws ec2 describe-vpc-endpoint-services --filter Name=service-type,Values=Interface --query ServiceNames
  validation {
    condition = contains([
      "ec2",
      "ec2messages",
      "ecr.api",
      "ecr.dkr",
      "ecs",
      "ecs-agent",
      "ecs-telemetry",
      "execute-api"
    ], var.service_name)
    error_message = "Allowed values for service_name are \"ec2\", \"ec2messages\", \"ecr.api\", \"ecr.dkr\", \"ecs\", \"ecs-agent\", \"ecs-telemetry\", \"execute-api\"."
  }
}
