module "vpce_interface_api_gw" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/interface?ref=aws-vpce-interface-v1.0.0"

  env          = var.env
  env_inst     = var.env_inst
  service_name = "execute-api"
  name         = local.app_name

  vpc_tag_name = format("%s-%s", var.vpc_name_prefix, local.env)
}