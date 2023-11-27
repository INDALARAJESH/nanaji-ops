module "lambda_vpc_dependencies" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic-vpc-dependencies?ref=aws-lambda-basic-vpc-dependencies-v2.0.0"

  vpc_name_prefix = var.vpc_name_prefix

  name    = var.service
  env     = local.env
  service = local.app_name
}
