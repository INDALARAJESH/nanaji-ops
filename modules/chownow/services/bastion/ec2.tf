module "ec2_bastion" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.2"

  env                 = var.env
  ingress_tcp_allowed = ["22"]
  service             = "bastion"
  vpc_name_prefix     = var.vpc_name_prefix
  subnet_tag          = "public_base"
  security_group_ids = [
    data.aws_security_group.ingress_vpn_allow.id
  ]
}
