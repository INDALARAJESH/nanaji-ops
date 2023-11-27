module "ecs_cluster" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/cluster?ref={{cookiecutter.cluster_module_ref}}"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
