module "ecs_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description = "security group to allow outgoing connections from ${var.service} lambda functions to ${var.env} environment"
  env         = var.env
  name_prefix = var.service
  service     = var.service
  vpc_id      = data.aws_vpc.selected.id

  enable_egress_allow_all = 1
  cidr_blocks = [
    data.aws_vpc.selected.cidr_block
  ]
}
