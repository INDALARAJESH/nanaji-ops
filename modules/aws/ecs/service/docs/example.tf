module "ecs_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.7"

  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  app_security_group_id    = module.ecs.app_security_group_id
  ecs_cluster_id           = module.ecs.cluster_id
  env                      = "sb"
  service                  = "dms"
  service_role             = "task"
  td_container_definitions = data.template_file.dms_td_task.rendered
  vpc_name_prefix          = "nc"
}

module "ecs_service_target_group" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.7"

  ecs_execution_iam_policy = data.template_file.dms_ecs_execution_policy_base.rendered
  ecs_task_iam_policy      = data.template_file.dms_ecs_app_policy_base.rendered
  app_security_group_id    = module.ecs.app_security_group_id
  container_name           = "dms-app"
  container_port           = "1234"
  ecs_service_tg_arn       = data.aws_lb_target_group.tg.arn
  ecs_cluster_id           = data.aws_ecs_cluster.app.arn
  env                      = "sb"
  service                  = "dms"
  service_role             = "task"
  td_container_definitions = data.template_file.dms_td_task.rendered
  vpc_name_prefix          = "nc"
}
