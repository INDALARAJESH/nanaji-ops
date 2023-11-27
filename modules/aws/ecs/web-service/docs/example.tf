module "ecs_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/web-service?ref=aws-ecs-web-service-v2.1.1"

  ecs_execution_iam_policy = data.template_file.dms_ecs_execution_policy_base.rendered
  ecs_task_iam_policy      = data.template_file.dms_ecs_app_policy_base.rendered
  app_security_group_id    = module.ecs.app_security_group_id
  container_name           = "dms-app"
  container_port           = "1234"
  ecs_service_tg_arn       = [data.aws_lb_target_group.tg.arn]
  ecs_cluster_id           = data.aws_ecs_cluster.app.arn
  env                      = "sb"
  service                  = "dms"
  service_role             = "task"
  td_container_definitions = data.template_file.dms_td_task.rendered
  vpc_name_prefix          = "nc"
}
