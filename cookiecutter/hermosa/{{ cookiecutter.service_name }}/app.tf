module "app" {
  source                       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/{{ cookiecutter.module }}?ref={{ cookiecutter.module_ref }}"
  env                          = var.env
  env_inst                     = var.env_inst
  service                      = var.service
  depends_on                   = [module.configuration]
  alb_name_prefix              = var.alb_name_prefix
  cluster_name_prefix          = var.cluster_name_prefix
  alb_hostnames                = var.alb_hostnames
  web_ecr_repository_uri       = var.web_ecr_repository_uri
  web_container_image_version  = var.web_container_image_version
  api_ecr_repository_uri       = var.api_ecr_repository_uri
  api_container_image_version  = var.api_container_image_version
  task_ecr_repository_uri      = var.task_ecr_repository_uri
  task_container_image_version = var.task_container_image_version
  ops_config_version           = var.ops_config_version
}
