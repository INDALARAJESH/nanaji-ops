module "ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecr/public?ref=aws-ecr-public-v2.0.0"

  env     = var.env
  service = var.service
}
