#########################
# ECS Cluster Variables #
#########################

variable "custom_cluster_name" {
  description = "override for default cluster name"
  default     = ""
}

variable "ecs_cluster_setting_name" {
  description = "setting name to enable container insights on the cluster"
  default     = "containerInsights"
}

variable "ecs_cluster_setting_value" {
  description = "setting value to enable container insights on the cluster"
  default     = "enabled"
}
