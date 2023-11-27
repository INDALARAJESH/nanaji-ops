#########################
# General ECS Variables #
#########################

variable "service_role" {
  description = "node type web/admin/api/app"
}

variable "cwlog_group_name" {
  description = "name of cloudwatch log group for ecs task"
  default     = ""
}

variable "cwlog_retention_in_days" {
  description = "cloudwatch log group retention in days"
  default     = "90"
}

#################################
# ECS Task Definition Variables #
#################################

variable "ecs_execution_iam_policy" {
  description = "ecs execution IAM policy"
}

variable "ecs_task_iam_policy" {
  description = "ecs task IAM policy"
}

variable "td_requires_capabilities" {
  description = "ECS task definition requires compatibilities list"
  default     = ["FARGATE"]
}

variable "td_network_mode" {
  description = "ECS task definition network mode"
  default     = "awsvpc"
}

variable "td_cpu" {
  description = "ECS task definition cpu mode"
  default     = "1024"
}

variable "td_memory" {
  description = "ECS task definition memory allocation"
  default     = "2048"
}

variable "td_container_definitions" {
  description = "ECS task definition's container definitions"
}

variable "host_volumes" {
  type    = list(map(string))
  default = []
}

variable "task_lifecycle_ignore_changes" {
  description = "If set to true, the ECS task will have a lifecycle ignore changes block for container_definitions"
  default     = false
}
