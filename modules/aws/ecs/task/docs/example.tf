module "ecs_manage" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.3"

  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  env                      = local.env
  service                  = var.service
  service_role             = "manage"
  td_container_definitions = data.template_file.ecs_task_definition.rendered
}
