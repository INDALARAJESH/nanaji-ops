variable "env" {
  description = "unique environment/stage name"
}

variable "service" {
  description = "unique service name for project/application"
  default     = "launchdarkly-pipeline"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "shard_count" {
  description = "number of shard in kinesis data stream"
  default     = 1
}

locals {
  common_tags = {
    Environment = var.env,
    Service     = var.service,
    ManagedBy   = var.tag_managed_by
  }
}
