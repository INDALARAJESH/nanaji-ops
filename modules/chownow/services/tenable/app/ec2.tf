##########################
# Tenable EC2 Instance #
##########################

module "tenable_ec2_instance" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.6"

  custom_vpc_name             = var.vpc_name
  custom_ami_id               = local.ami_id
  custom_iam_instance_profile = aws_iam_instance_profile.tenable-ops-ro-profile.name
  custom_user_data            = data.template_file.user_data.rendered
  custom_key_pair             = "${local.env}-auth"
  env                         = var.env
  env_inst                    = var.env_inst
  instance_type               = var.instance_type
  root_volume_size            = var.root_volume_size
  service                     = var.service
  enable_dns_record_private   = 0
  security_group_ids          = local.internal_allow_sg
}
