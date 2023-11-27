module "sherlock_ecs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/ecs/base?ref=ecs-base-v1.0.9"

  container_name           = "${local.container_name}"
  container_port           = "${var.container_port}"
  ecs_app_iam_policy       = "${data.template_file.sherlock_ecs_app_policy_base.rendered}"
  ecs_service_tg_arn       = "${module.alb_tg.tg_arn}"
  env                      = "${var.env}"
  env_inst                 = "${var.env_inst}"
  service                  = "${var.service}"
  service_role             = "api"
  td_container_definitions = "${data.template_file.sherlock_td_api.rendered}"
  vpc_name_prefix          = "${var.vpc_name_prefix}"
}

module "sherlock_ecs_scanner_task" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/ecs/task?ref=ecs-task-v2.1.0"

  execution_iam_role_arn   = "${module.sherlock_ecs.app_iam_role_arn}"
  task_iam_role_arn        = "${module.sherlock_ecs.app_iam_role_arn}"
  env                      = "${var.env}"
  env_inst                 = "${var.env_inst}"
  service                  = "${var.service}"
  service_role             = "scanner"
  td_memory                = "${var.sherlock_scanner_memory_limit}"
  td_container_definitions = "${data.template_file.sherlock_td_scanner.rendered}"
}
