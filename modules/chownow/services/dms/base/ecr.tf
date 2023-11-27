module "ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecr/basic?ref=aws-ecr-basic-v2.0.0"

  count = var.enable_ecr

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
