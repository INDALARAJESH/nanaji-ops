module "ecs_td_data-redaction" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.2"

  env          = var.env
  env_inst     = var.env_inst
  service      = var.service
  service_role = "task"

  td_container_definitions = templatefile("${path.module}/templates/container-definitions/data-redaction.json", {
    service               = var.service
    image_repository      = var.image_repository_arn
    env                   = var.env
    version               = var.image_version
    app_name              = var.app_name
    target_db             = var.target_db
    dd_api_key_secret_arn = module.datadog_api_key_secret.secret_arn
    region                = var.region
  })

  td_cpu    = var.td_cpu
  td_memory = var.td_memory

  ecs_execution_iam_policy = templatefile("${path.module}/templates/iam-policies/task_execution_role.json", {
    service    = var.service
    env        = local.env
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  })
  ecs_task_iam_policy = templatefile("${path.module}/templates/iam-policies/task_role.json", {
    region                              = data.aws_region.current.name
    role_name_with_path                 = local.role_name_with_path
    account_id                          = data.aws_caller_identity.current.account_id
    source_cluster_parameter_group_name = local.source_cluster_parameter_group_name
    source_db_cluster_instance_name     = local.source_db_cluster_instance_name
    source_db_instance_name             = local.source_db_instance_name
    source_cluster_snapshot_name        = local.source_cluster_snapshot_name
    target_db_cluster_instance_name     = local.target_db_cluster_instance_name
    target_db_instance_name             = local.target_db_instance_name
    target_cluster_snapshot_name        = local.target_cluster_snapshot_name
    target_cluster_parameter_group_name = local.target_cluster_parameter_group_name
  })
}
