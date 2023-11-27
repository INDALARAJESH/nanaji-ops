module "sherlock_cloudwatch" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/ecs/cloudwatch?ref=cloudwatch-v1.0.0"

  cloudwatch_event_rule_description = "Cloudwatch event rule for ${var.service}-${local.env}"
  schedule                          = "${var.schedule}"
  launch_type                       = "${var.launch_type}"
  platform_version                  = "${var.platform_version}"
  program                           = "${var.program}"
  path                              = "${var.path}"
  task_definition_arn               = "${module.sherlock_ecs_scanner_task.ecs_task_definition_arn}"
  ecs_arn                           = "${module.sherlock_ecs.aws_ecs_cluster}"
  env                               = "${var.env}"
  env_inst                          = "${var.env_inst}"
  service                           = "${var.service}"
  vpc_name_prefix                   = "${var.vpc_name_prefix}"
  security_group                    = "${module.sherlock_ecs.aws_ecs_security_group_id}"
}
