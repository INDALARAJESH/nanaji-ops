module "loyalty_ecs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/base?ref=aws-ecs-base-v2.0.0"

  container_name            = local.container_name
  container_port            = var.container_port
  ecs_app_iam_policy        = data.template_file.loyalty_ecs_app_policy_base.rendered
  ecs_service_tg_arn        = module.public_tg.tg_arn
  ecs_service_desired_count = var.ecs_service_desired_count
  env                       = var.env
  env_inst                  = var.env_inst
  log_retention_in_days     = var.log_retention_in_days
  service                   = var.service
  service_role              = "api"
  td_container_definitions  = data.template_file.loyalty_td_api.rendered
  vpc_name_prefix           = var.vpc_name_prefix
}
