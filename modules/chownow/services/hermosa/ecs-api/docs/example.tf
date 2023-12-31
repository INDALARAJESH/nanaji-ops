module "api" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-api?ref=cn-hermosa-ecs-api-v2.4.5"
  env                         = var.env
  env_inst                    = var.env_inst
  service                     = var.service
  service_id                  = "api"
  alb_name                    = local.alb_name_api
  cluster_name                = local.cluster_name
  alb_hostnames               = [local.api_hostname]
  listener_rule_priority      = 2
  wait_for_steady_state       = var.wait_for_steady_state
  configuration_secret_arn    = module.secrets.configuration_secret_arn
  ssl_key_secret_arn          = module.secrets.ssl_key_secret_arn
  ssl_cert_secret_arn         = module.secrets.ssl_cert_secret_arn
  web_ecr_repository_uri      = var.web_ecr_repository_uri
  web_container_image_version = var.web_container_image_version
  api_ecr_repository_uri      = var.api_ecr_repository_uri
  api_container_image_version = var.api_container_image_version
}
