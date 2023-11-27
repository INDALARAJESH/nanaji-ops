module "ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecr/basic?ref=aws-ecr-basic-v2.0.1"

  count = var.enable_ecr

  custom_name = var.service
  env         = var.env
  service     = var.service
}
