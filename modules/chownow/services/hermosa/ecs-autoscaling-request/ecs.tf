module "ecs_web_autoscale" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.0.1"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service_name

  min_capacity             = var.min_count
  max_capacity             = var.max_count
  policy_scale_in_cooldown = var.policy_scale_in_cooldown
  target_resource_id       = "service/${var.cluster_name}/${var.service_name}"

  policy_target_conditions = [
    {
      metric         = "ALBRequestCountPerTarget"
      value          = var.request_count_per_target
      resource_label = "app/${data.aws_lb.main.name}/${element(split("/", data.aws_lb.main.arn), length(split("/", data.aws_lb.main.arn)) - 1)}/targetgroup/${var.target_group_name}/${element(split("/", data.aws_lb_target_group.main.arn), length(split("/", data.aws_lb_target_group.main.arn)) - 1)}"
    },
  ]
}
