module "ecs_task_autoscale" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service_name

  min_capacity             = var.min_count
  max_capacity             = var.max_count
  policy_scale_in_cooldown = var.policy_scale_in_cooldown
  target_resource_id       = "service/${var.cluster_name}/${var.service_name}"

  policy_target_conditions = [
    {
      metric = "ECSServiceAverageCPUUtilization"
      value  = var.average_cpu_utilization
    },
    {
      metric = "ECSServiceAverageMemoryUtilization"
      value  = var.average_memory_utilization
    },
  ]
}
