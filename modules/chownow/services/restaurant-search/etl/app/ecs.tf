module "restaurant_search_etl_manage_ecs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.2"

  ecs_execution_iam_policy = data.aws_iam_policy_document.etl_manage_ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.etl_manage_ecs_task_policy.json
  env                      = local.env
  service                  = var.service
  service_role             = "manage"
  td_container_definitions = local.etl_manage_ecs_td
  td_cpu                   = var.td_cpu
  td_memory                = var.td_memory
}
