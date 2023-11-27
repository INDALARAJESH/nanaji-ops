module "autoscale_target" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"

  env     = "sb"
  service = var.service_name

  target_resource_id = "service/${var.cluster_name}/${var.service_name}"
}

module "autoscale_step_1" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"

  env     = "sb"
  service = var.service_name

  target_resource_id  = "service/${var.cluster_name}/${var.service_name}"
  scaling_policy_type = "step"

  alarm_out_dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }
}

module "autoscale_step_2" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"

  env     = "sb"
  service = var.service_name

  target_resource_id  = "service/${var.cluster_name}/${var.service_name}"
  scaling_policy_type = "step"

  alarm_out_dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  policy_step_adjustments_out = [
    {
      # Between threshold and threshold+30% scale by +20%
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 30
      scaling_adjustment          = 20
    },
    {
      # Between threshold+30% and infiniti scale by +50%
      metric_interval_lower_bound = 30
      scaling_adjustment          = 50
    },
  ]
}

module "autoscale_scheduled" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"
  # wait for autoscaling in api module to be set
  depends_on          = [module.api]
  env                 = var.env
  service             = local.service
  scaling_policy_type = "scheduled"
  min_capacity        = 1
  max_capacity        = 20
  scheduled_scalings = [
    { # everyday at 15:00 PM UTC
      schedule     = "cron(30 17 * * ? *)"
      min_capacity = 5
      max_capacity = 20
    },
    { # everyday at 17:00 PM UTC
      schedule     = "cron(00 18 * * ? *)"
      min_capacity = 1
      max_capacity = 20
    }
  ]
  target_resource_id = "service/${local.cluster_name}/${local.service}-${local.env}"
}
