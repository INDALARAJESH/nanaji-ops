module "privatelink_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/privatelink/web/base?ref=aws-privatelink-web-base-v2.0.4"

  providers = {
    aws.service_consumer = aws.service_consumer
    aws.service_provider = aws.service_provider
  }

  env      = var.env
  env_inst = var.env_inst
  service  = var.service


  # Provider Variables
  service_provider_alb_name         = "${var.service}-pub-${local.env}"
  service_provider_private_dns_name = "${local.dns_name}.${local.env}.svpn.chownow.com"
  service_provider_vpc_name         = var.service_provider_vpc_name
  service_provider_aws_account_ids  = [var.service_consumer_aws_account_id]

  # Consumer Variables
  service_consumer_vpc_name             = var.service_consumer_vpc_name
  service_consumer_extra_sg_cidr_blocks = var.service_consumer_extra_sg_cidr_blocks
}
