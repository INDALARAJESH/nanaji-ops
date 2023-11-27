variable "task_ecr_repository_uri" {
  default = "449190145484.dkr.ecr.us-east-1.amazonaws.com/hermosa"
}

variable "task_container_image_version" {
  default = "{{cookiecutter.hermosa_task_image_tag}}"
}

variable "task_ecs_service_desired_count" {
  default = {{cookiecutter.task_desired_count}}
}

locals {
  task_service_id = "task"
  task_service    = var.deployment_suffix == "" ? "${var.service}-${local.task_service_id}-${local.env}" : "${var.service}-${local.task_service_id}-${var.deployment_suffix}-${local.env}"
}
