module "bastion" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.4"

  associate_public_ip_address = true
  env                         = local.env
  ingress_tcp_allowed         = ["22"]
  service                     = local.name
  custom_ami_id               = data.aws_ami.datavail.id
  custom_key_pair             = "${local.env}-auth"
  custom_vpc_name             = local.env
  subnet_tag                  = "public_base"

  security_group_ids = [
    data.aws_security_group.ingress_vpn_allow.id
  ]

  extra_tags = {
    FQDNPublic = "${local.name}0.${local.env}.svpn.${var.domain}"
  }
}

# Creating a security group to attach to Aurora RDS to allow communication between the bastion instance and Aurora database
module "instance_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.0"

  description = "security group to allow incoming connections from ${var.service} to database"
  env         = var.env
  name_prefix = "db-allow"
  service     = var.service
  vpc_id      = data.aws_vpc.selected.id

  ingress_tcp_allowed = ["3306"]
  cidr_blocks         = ["${module.bastion.private_ips[0]}/32"]
}
