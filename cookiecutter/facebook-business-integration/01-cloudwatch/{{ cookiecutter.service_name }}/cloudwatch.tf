module "cloudwatch" {
  source     = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-cloudwatch?ref=aws-api-gateway-cloudwatch-v2.0.0"
  env        = var.env
  create_iam = 1
}
