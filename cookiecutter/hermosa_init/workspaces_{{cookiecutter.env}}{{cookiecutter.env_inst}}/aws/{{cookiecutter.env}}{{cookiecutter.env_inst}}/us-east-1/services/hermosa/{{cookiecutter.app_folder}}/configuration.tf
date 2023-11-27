module "configuration" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-configuration?ref={{cookiecutter.configuration_module_ref}}"
  env      = var.env
  env_inst = var.env_inst
  service  = "${var.service}-${var.deployment_suffix}"
}
