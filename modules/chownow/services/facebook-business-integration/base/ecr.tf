module "ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecr/basic?ref=aws-ecr-basic-v2.0.0"

  env     = var.env
  service = var.service

  custom_name = "fbe"
}
