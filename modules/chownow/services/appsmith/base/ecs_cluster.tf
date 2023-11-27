module "ecs_cluster" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/cluster?ref=aws-ecs-cluster-v2.0.0"

  env     = var.env
  service = var.service
}
