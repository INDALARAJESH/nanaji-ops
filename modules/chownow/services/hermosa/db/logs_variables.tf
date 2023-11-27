variable "enable_cloudwatch_logs" {
  description = "Enable cloudatch to Datadog logs"
  default     = 0
}


locals {
  cloudwatch2datadog_lambda = "cloudwatch2datadog-${local.env}"
  cloudwatch_log_group_name = "/aws/rds/cluster/db-${local.env}-aurora-cluster/error"
}
