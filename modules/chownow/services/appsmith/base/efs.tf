resource "aws_efs_file_system" "efs" {
  creation_token = "efs-${var.service}-${var.env}-${var.env_inst}"
  encrypted      = "true"
}

resource "aws_efs_mount_target" "efs-mount" {
  count           = length(toset(data.aws_subnets.private.ids))
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = element(toset(data.aws_subnets.private.ids)[*], count.index)
  security_groups = [module.efs_sg.id]
}

module "efs_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description             = "security group to allow incoming connections from ecs ${var.service} ${var.env} ${var.env_inst} to efs-${var.service}-${var.env}-${var.env_inst}"
  enable_egress_allow_all = var.enable_egress_allow_all
  env                     = var.env
  ingress_tcp_allowed     = [2049, 2999]
  name_prefix             = "${var.service}-${var.env}-${var.env_inst}-ingress"
  service                 = var.service
  vpc_id                  = data.aws_vpc.selected.id

  cidr_blocks = [data.aws_vpc.selected.cidr_block]
}
