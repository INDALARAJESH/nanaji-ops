module "privatelink_provider" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/privatelink/web/provider?ref=aws-privatelink-web-provider-v2.0.2"

  count = var.enable_alb_public == 1 && var.enable_privatelink == 1 ? 1 : 0

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  service_provider_aws_account_ids  = toset(var.service_provider_aws_account_ids)
  service_provider_alb_name         = module.alb_public[0].alb_name
  service_provider_private_dns_name = "${var.service}.${local.dns_zone}"
  service_provider_vpc_name         = local.vpc_name
}
