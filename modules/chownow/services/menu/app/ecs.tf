module "ecs_base_web" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/base?ref=aws-ecs-base-v2.1.4"

  env             = var.env
  env_inst        = var.env_inst
  service         = local.service
  service_role    = "web"
  vpc_name_prefix = var.vpc_name_prefix
  td_cpu          = var.cpu
  td_memory       = var.memory

  # ecs service
  ecs_service_tg_arn     = data.aws_lb_target_group.tg_web.arn
  enable_execute_command = var.enable_execute_command

  # ecs task definition
  container_name           = local.container_web_name
  container_port           = var.container_web_port
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_app_policy.json
  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json

  td_container_definitions = templatefile("${path.module}/templates/ecs_web.json.tpl", {
    env                = local.env # Not var.env
    service            = local.service
    name               = local.container_web_name
    image_registry_url = var.container_web_image_registry_url
    image_name         = var.container_web_image_name
    image_tag          = var.container_web_image_tag
    container_port     = var.container_web_port
    host_port          = var.container_web_port
    database_user      = var.database_user
    database_password  = data.aws_secretsmanager_secret_version.db_user_password.secret_id
    database_host      = data.aws_rds_cluster.db_cluster.endpoint
    readonly_db_host   = data.aws_rds_cluster.db_cluster.reader_endpoint
    database_name      = var.database_name
    database_port      = data.aws_rds_cluster.db_cluster.port
    dd_service         = local.dd_service
    dd_env             = local.dd_env
    jwt_secret         = data.aws_secretsmanager_secret_version.jwt_auth_secret.secret_id
    ld_sdk_key         = data.aws_secretsmanager_secret_version.ld_sdk_key_secret.secret_id

    # firelens
    cwlogs_name        = module.ecs_base_web.cloudwatch_log_group_name
    cwlogs_region      = data.aws_region.current.name
    cwlogs_prefix      = "web"
    log_image_repo     = data.aws_ssm_parameter.fluentbit.value
    log_container_name = var.firelens_container_name

    # logConfiguration
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = join(",", [
      "env:${local.dd_env}",
      "service:${local.dd_service}",
      "cn_namespace:${local.dd_service}",
    ])
    lc_apikey_arn = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
  })
}

module "ecs_base_autoscale" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.0.1"

  env                = var.env
  env_inst           = var.env_inst
  service            = local.service
  min_capacity       = var.web_ecs_service_desired_count
  max_capacity       = var.web_ecs_service_max_count
  target_resource_id = "service/${module.ecs_base_web.cluster_name}/${module.ecs_base_web.service_name}"
}

module "ecs_td_manage" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.2"

  env          = var.env
  env_inst     = var.env_inst
  service      = local.service
  service_role = "manage"

  # ecs task definition
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json

  td_container_definitions = templatefile("${path.module}/templates/ecs_task_manage.json.tpl", {
    env                = local.env # Not var.env
    name               = local.container_manage_name
    image_registry_url = var.container_web_image_registry_url
    image_name         = var.container_web_image_name
    image_tag          = var.container_web_image_tag
    memory             = var.task_memory
    cpu                = var.task_cpu
    database_user      = var.database_user
    database_password  = data.aws_secretsmanager_secret_version.db_user_password.secret_id
    database_host      = data.aws_rds_cluster.db_cluster.endpoint
    readonly_db_host   = data.aws_rds_cluster.db_cluster.reader_endpoint
    database_name      = var.database_name
    database_port      = data.aws_rds_cluster.db_cluster.port
    dd_service         = local.dd_service
    dd_env             = local.dd_env
    jwt_secret         = data.aws_secretsmanager_secret_version.jwt_auth_secret.secret_id
    container_command  = var.container_command
    ld_sdk_key         = data.aws_secretsmanager_secret_version.ld_sdk_key_secret.secret_id


    # firelens
    cwlogs_name        = module.ecs_base_web.cloudwatch_log_group_name
    cwlogs_region      = data.aws_region.current.name
    cwlogs_prefix      = "manage"
    log_image_repo     = data.aws_ssm_parameter.fluentbit.value
    log_container_name = var.firelens_container_name

    # logConfiguration
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = join(",", [
      "env:${local.dd_env}",
      "service:${local.dd_service}",
      "cn_namespace:${local.dd_service}",
    ])
    lc_apikey_arn = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
  })
}
