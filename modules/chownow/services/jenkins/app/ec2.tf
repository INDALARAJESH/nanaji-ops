module "jenkins_ec2" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.7"

  associate_public_ip_address = true
  custom_instance_name        = var.jenkins_ec2_name
  custom_ami_id               = var.ami_id
  instance_type               = var.instance_type
  service                     = "Jenkins" # changing this to the correct lowercase destroys stuff (not worth it)
  custom_vpc_name             = var.env
  env                         = var.env
  custom_key_pair             = "${var.env}-auth"
  root_volume_size            = 150
  subnet_tag_filter           = "Name"
  subnet_tag                  = local.subnet

  security_group_ids = [
    data.aws_security_group.internal_allow.id,
  ]

  extra_tags = {
    ServerName = "jankyns0"
  }
}
