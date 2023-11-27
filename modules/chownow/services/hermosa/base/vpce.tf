module "vpc_primary" {
  source       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/gateway?ref=aws-vpce-gateway-v2.0.0"
  count        = var.enable_vpce
  env          = var.env
  env_inst     = var.env_inst
  service_name = "s3"
  vpc_tag_name = local.vpc_name
}
