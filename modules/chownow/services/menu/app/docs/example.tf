module "app" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/app?ref=cn-menu-app-v2.0.9"
  env             = var.env
  env_inst        = var.env_inst
  vpc_name_prefix = var.vpc_name_prefix

  container_web_image_registry_url = var.container_web_image_registry_url
  container_web_image_name         = var.container_web_image_name
  container_web_image_tag          = var.container_web_image_tag

  database_user = "root"
}
