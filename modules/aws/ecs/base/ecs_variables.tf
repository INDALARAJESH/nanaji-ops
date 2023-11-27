#########################
# General ECS Variables #
#########################

variable "service_role" {
  description = "node type web/admin/api/app"
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION"
  default     = "TASK_DEFINITION"
}

#########################
# ECS Cluster Variables #
#########################

variable "ecs_cluster_setting_name" {
  description = "setting name to enable container insights on the cluster"
  default     = "containerInsights"
}

variable "ecs_cluster_setting_value" {
  description = "setting value to enable container insights on the cluster"
  default     = "enabled"
}

#################################
# ECS Task Definition Variables #
#################################

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

#########################
# ECS Service Variables #
#########################

variable "additional_security_group_ids" {
  description = "list of additional security group ids"
  default     = []
}

variable "ecs_service_launch_type" {
  description = "launch type for ECS service"
  default     = "FARGATE"
}

variable "ecs_service_platform_version" {
  description = "platform version for Fargate"
  default     = "1.4.0"
}

variable "ecs_service_desired_count" {
  description = "ECS service count"
  default     = 2
}

variable "ecs_service_tg_arn" {
  description = "ECS Service target group ARN"
}

variable "container_port" {
  description = "ECS Service container port"
}

variable "container_name" {
  description = "ECS Service container name"
}

variable "custom_ecs_service_name" {
  description = "custom ECS Service name"
  default     = ""
}

variable "wait_for_steady_state" {
  description = "wait for service to come up as healthy before finishing terraform run"
  default     = false
}

variable "enable_execute_command" {
  description = "enable execution of command into a container"
  default     = false
}

##############################
# ALB Target Group Variables #
##############################

variable "alb_tg_protocol" {
  description = "ALB target group protocol"
  default     = "HTTP"
}

variable "alb_tg_target_type" {
  description = "ALB target group target type"
  default     = "ip"
}

variable "alb_tg_hc_path" {
  description = "ALB target group health check path"
  default     = "/health"
}

variable "alb_tg_hc_protocol" {
  description = "ALB target group health check protocol"
  default     = "HTTP"
}

variable "alb_tg_hc_matcher" {
  description = "ALB target group health check matcher"
  default     = "200"
}
