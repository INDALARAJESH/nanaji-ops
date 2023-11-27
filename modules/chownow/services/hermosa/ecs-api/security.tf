module "web_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description             = "security group to allow incoming connections from api ${local.service} to ${var.env} environment"
  enable_egress_allow_all = var.enable_egress_allow_all
  env                     = var.env
  env_inst                = var.env_inst
  ingress_tcp_allowed     = [var.web_container_port]
  name_prefix             = "ingress"
  service                 = local.service_full
  vpc_id                  = data.aws_vpc.selected.id

  cidr_blocks = [data.aws_vpc.selected.cidr_block]
}
