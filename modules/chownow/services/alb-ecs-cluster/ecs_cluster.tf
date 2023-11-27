module "ecs_cluster" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/cluster?ref=aws-ecs-cluster-v2.0.0"
  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
