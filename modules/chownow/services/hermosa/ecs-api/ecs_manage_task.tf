module "ecs_task_manage" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.1"

  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  env                      = var.env
  env_inst                 = var.env_inst
  service                  = var.service
  service_role             = local.manage_role
  td_cpu                   = var.manage_task_cpu
  td_memory                = var.manage_task_memory
  host_volumes             = []
  td_container_definitions = local.manage_container_definitions
}
