module "marketplace_ecs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/base?ref=aws-ecs-base-v2.1.6"

  container_name            = local.marketplace_container_name
  container_port            = var.marketplace_container_port
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  enable_execute_command    = var.enable_execute_command
  ecs_service_tg_arn        = module.public_tg.tg_arn
  ecs_service_desired_count = var.ecs_service_desired_count
  env                       = var.env
  env_inst                  = var.env_inst
  log_retention_in_days     = var.log_retention_in_days
  service                   = var.service
  service_role              = "service"
  td_container_definitions  = local.marketplace_container_definitions
  vpc_name_prefix           = var.vpc_name_prefix
  custom_vpc_name           = var.custom_vpc_name
  td_cpu                    = var.task_cpu
  td_memory                 = var.task_memory
  wait_for_steady_state     = var.wait_for_steady_state
  extra_tags                = local.common_tags
  propagate_tags            = var.propagate_tags
}

module "marketplace_ecs_autoscale" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.0.1"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  min_capacity             = local.env == "prod" ? var.web_scaling_min_capacity : 2
  max_capacity             = local.env == "prod" ? var.web_scaling_max_capacity : 4
  policy_scale_in_cooldown = local.env == "prod" ? var.web_policy_scale_in_cooldown : 1
  target_resource_id       = "service/${module.marketplace_ecs.cluster_name}/${module.marketplace_ecs.service_name}"

  # Turning this into a variable is problematic because passing it to a
  # module forces interpolation. 0.12 might fix this
  policy_target_conditions = [
    {
      metric = "ECSServiceAverageCPUUtilization"
      value  = 50
    },
    {
      metric = "ECSServiceAverageMemoryUtilization"
      value  = 50
    },
  ]
}
