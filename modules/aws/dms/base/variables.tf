variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "custom_vpc_name" {
  description = "custom vpc name for resources to be created inside"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}
locals {
  env                = "${var.env}${var.env_inst}"
  repl_instance_id   = "repl-${var.service}-${local.env}"
  vpc_name           = var.custom_vpc_name == "" ? "main-${local.env}" : var.custom_vpc_name
  repl_task_settings = var.custom_repl_task_settings != "" ? var.custom_repl_task_settings : templatefile("${path.module}/templates/repl_task_settings.json", { repl_task_log_level = var.repl_task_log_level, lob_max_size = var.lob_max_size })


  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }
}
