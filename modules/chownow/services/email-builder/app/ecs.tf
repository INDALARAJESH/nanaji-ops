module "email_builder_ecs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/base?ref=aws-ecs-base-v2.1.3"

  container_name            = local.container_name
  container_port            = var.container_port
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.template_file.email_builder_ecs_app_policy_base.rendered
  ecs_service_tg_arn        = module.public_tg.tg_arn
  ecs_service_desired_count = var.ecs_service_desired_count
  env                       = var.env
  env_inst                  = var.env_inst
  log_retention_in_days     = var.log_retention_in_days
  service                   = var.service
  service_role              = "api"
  td_container_definitions  = data.template_file.email_builder_td_api.rendered
  vpc_name_prefix           = var.vpc_name_prefix

}
